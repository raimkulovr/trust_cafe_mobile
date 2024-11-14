import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:component_library/typedefs.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required this.initialPost,
    required String? postId,
    required this.appUser,
    required UserRepository userRepository,
    required ContentRepository contentRepository,
    required OnPostUpdatedCallback? onPostUpdated,
    required VoidCallback? onPostRemoved,
  }) :  assert(initialPost!=null || postId!=null, 'Either post or postId must be provided'),
        _contentRepository = contentRepository,
        _userRepository = userRepository,
        _onPostUpdated = onPostUpdated,
        _onPostRemoved = onPostRemoved,
        postId = postId ?? initialPost!.postId,
        super(PostState(
          post: initialPost ?? Post.empty,
          isBlurHidden: initialPost?.blurLabel!=null,
          isUpvoted: initialPost!=null ? contentRepository.isSubjectUpvoted(initialPost.sk) : null,))
  {
    log('post cubit created: ${initialPost?.postId ?? postId}');

    if(initialPost!=null){
      _getReaction();
    } else {
      _loadPost(postId!);
    }

    _votesChangesSubscription = contentRepository.userVotesStream().listen((votes) {
      emit(state.copyWith(isUpvoted: Wrapped.value(contentRepository.isSubjectUpvoted(initialPost?.sk ?? 'post#$postId'))));
    },);
  }

  final Post? initialPost;
  final String postId;
  final AppUser appUser;
  final OnPostUpdatedCallback? _onPostUpdated;
  final VoidCallback? _onPostRemoved;
  final UserRepository _userRepository;
  final ContentRepository _contentRepository;
  late final StreamSubscription _votesChangesSubscription;

  Future<void> _loadPost(String postId) async {
    final post = await _contentRepository.getPostFromNetwork(postId);
    if(post!=null){
      emit(PostState(
        post: post,
        isBlurHidden: post.blurLabel!=null,
        isUpvoted: state.isUpvoted,
      ));
      await _getReaction();
    } else {
      emit(PostState(
          post: Post.notFound,
          isUpvoted: state.isUpvoted,
          error: PostStateErrors.load,
      ));
    }
  }

  Future<void> _getReaction() async {
    final post = state.post;
    if(post.isEmpty || appUser.isGuest || post.statistics.reactions.isEmpty) return;

    final cachedReaction = await _contentRepository.getCachedReaction(post.sk);
    if(!isClosed) emit(state.copyWith(reaction: cachedReaction));

    await Future.delayed(const Duration(seconds: 1, milliseconds: 500), () async {
      if(!isClosed) {
        final networkReaction = await _contentRepository.getNetworkReaction(post.sk);
        if (!isClosed) emit(state.copyWith(reaction: networkReaction));
      }
    });
  }

  Future<void> refreshPost() async {
    _loadPost(postId);
  }

  Future<void> castReaction(String reaction) async {
    final post = state.post;
    if(post.isEmpty) return;

    final reactionInitial = state.reaction;
    final reactionsInitial = state.reactions;

    if(reaction == state.reaction){
      emit(state.copyWith(reaction: 'none', reactions: state.reactions.modifyBy(reaction, add: false)));
    } else if(state.reaction!='none'){
      emit(state.copyWith(reaction: reaction, reactions: state.reactions
          .modifyBy(state.reaction, add: false)
          .modifyBy(reaction, add: true))
      );
    } else if(state.reaction=='none'){
      emit(state.copyWith(reaction: reaction, reactions: state.reactions.modifyBy(reaction, add: true)));
    }

    try{
      final (String action, Reactions reactions) = await _contentRepository.castReaction(
        reaction: reaction,
        sk: post.sk,
        pk: post.pk,
        slug: post.postId,
        entity: 'post',
        post: post.copyWith(
            statistics: post.statistics.copyWith(
              voteCount: state.voteCount,
              voteValueSum: state.voteValueSum,
              reactions: state.reactions,
            )),
      );
      if(!isClosed) {
        emit(switch(action){
          'add' || 'update' => state.copyWith(reaction: reaction, reactions: reactions),
          'remove' => state.copyWith(reaction: 'none', reactions: reactions),
          _ => state
        });
      }
    } catch (e) {
      emit(state.copyWith(
          reaction: reactionInitial,
          reactions: reactionsInitial,
          error: const Wrapped.value(PostStateErrors.reactionCast)));
      _resetError();
    }
  }

  Future<void> castVote({
    required bool? isUpvote,
  }) async {
    final post = state.post;
    if(post.isEmpty) return;

    final isUpvoted = state.isUpvoted;
    if (isUpvoted == isUpvote) {
      return;
    }
    final voteValue = appUser.voteValue;

    final voteSumInitial = state.voteValueSum;
    final voteCountInitial = state.voteCount;

    int voteSum = state.voteValueSum;
    int voteCount = state.voteCount;

    if (isUpvoted != null) {
      voteSum += isUpvoted ? -voteValue : voteValue;
      voteCount -= 1;
    }
    if (isUpvote != null) {
      voteSum += isUpvote ? voteValue : -voteValue;
      voteCount += 1;
    }

    emit(state.copyWith(
        voteValueSum: voteSum,
        voteCount: voteCount,
        isUpvoted: Wrapped.value(isUpvote),
    ));

    try {
      _votesChangesSubscription.pause();
      await _contentRepository.castUserVote(
        isUp: isUpvote,
        sk: post.sk,
        pk: post.pk,
        slug: post.postId,
        userslug: appUser.slug,
        voteValue: voteValue,
        post: post.copyWith(
            statistics: post.statistics.copyWith(
              voteCount: state.voteCount,
              voteValueSum: state.voteValueSum,
              reactions: state.reactions,
            )),
      );
      _votesChangesSubscription.resume();
    } catch(e) {
      emit(state.copyWith(
          isUpvoted: Wrapped.value(isUpvoted),
          voteValueSum: voteSumInitial,
          voteCount: voteCountInitial,
          error: const Wrapped.value(PostStateErrors.voteCast)
      ));
      _resetError();
    }
  }

  Future<void> translate() async {
    final post = state.post;
    if(post.isEmpty) return;

    if(state.translation==null){
      try {
        emit(state.copyWith(translationIsProcessing: true));
        final result = await _contentRepository.translateContent(
            itemId: post.postId, content: state.postText, targetLocale: _userRepository.getTranslationTarget());
        emit(state.copyWith(
            translation: Wrapped.value('Translated from ${result.from}:\n${result.translation}'),
            translationIsProcessing: false,
        ));
      } catch(e){
        emit(state.copyWith(error: const Wrapped.value(PostStateErrors.translation), translationIsProcessing: false));
        _resetError();
      }
    } else {
      emit(state.copyWith(translation: const Wrapped.value(null)));
    }
  }

  Future<void> editPost(({
        String postText,
        bool collaborative,
        String cardUrl,
        String? blurLabel,
  }) updatedPost) async {
    final post = state.post;
    if(post.isEmpty) return;

    final initialPostText = state.postText;
    final initialCollaborative = state.collaborative;
    final initialCardUrl = state.cardUrl;
    final initialBlurLabel = state.blurLabel;
    try {
      emit(state.copyWith(postText: updatedPost.postText, collaborative: updatedPost.collaborative, cardUrl: updatedPost.cardUrl, blurLabel: Wrapped.value(updatedPost.blurLabel)));
      final result = await _contentRepository.updatePost(
          keySk: post.sk,
          keyPk: state.postPk,
          keySlug: post.postId,
          postText: updatedPost.postText,
          collaborative: updatedPost.collaborative,
          cardUrl: updatedPost.cardUrl,
          blurLabel: updatedPost.blurLabel,
      );
      emit(state.copyWith(postText: result.postText, collaborative: result.collaborative, cardUrl: result.cardUrl, blurLabel: Wrapped.value(result.blurLabel)));
    } catch (e) {
      log('error trying to edit post: $e');
      emit(state.copyWith(postText: initialPostText, collaborative: initialCollaborative, cardUrl: initialCardUrl, blurLabel: Wrapped.value(initialBlurLabel),
          error: const Wrapped.value(PostStateErrors.edit)));
      _resetError();
    }
  }

  Future<void> movePostToUserProfile() async {
    final post = state.post;
    if(post.isEmpty) return;

    final initialPostData = state.postData.copyWith();
    final postAuthor = post.data.createdByUser;
    final newPostOrigin = UserProfilePostOrigin(
        slug: postAuthor.slug,
        sk: 'userprofile#${postAuthor.slug}',
        pk: 'userprofile#${postAuthor.slug}',
        fname: postAuthor.fname,
        lname: postAuthor.lname,
        userId: postAuthor.userId,
    );
    final newPostData = state.postData.copyWith(
        userprofile: Wrapped.value(newPostOrigin),
        maintrunk: const Wrapped.value(null),
        subwiki: const Wrapped.value(null));

    emit(state.copyWith(postData: newPostData));
    try{
      await _contentRepository.movePostToUserProfile(
          keyPk: initialPostData.originPkSk,
          keySk: post.sk, postId: post.postId,
      );
    } catch (e) {
      emit(state.copyWith(postData: initialPostData, error: const Wrapped.value(PostStateErrors.movement)));
      _resetError();
    }
  }

  Future<void> updatePostBranch({
    required String slug,
    required String label,
  }) async {
    final post = state.post;
    if(post.isEmpty) return;

    final initialPostData = state.postData.copyWith();
    final newPostOrigin = SubwikiPostOrigin(
        slug: slug,
        sk: 'subwiki#$slug',
        pk: 'subwiki#$slug',
        label: label,
    );
    final newPostData = state.postData.copyWith(
        userprofile: const Wrapped.value(null),
        maintrunk: const Wrapped.value(null),
        subwiki: Wrapped.value(newPostOrigin));

    emit(state.copyWith(postData: newPostData));
    try{
      await _contentRepository.updatePostBranch(
          keyPk: initialPostData.originPkSk,
          keySk: post.sk,
          postId: post.postId,
          destinationBranchSlug: slug,
          updatedPost: post,
      );
    } catch (e) {
      emit(state.copyWith(postData: initialPostData, error: const Wrapped.value(PostStateErrors.movement)));
      _resetError();
    }
  }

  Future<void> archivePost() async {
    final post = state.post;
    if(post.isEmpty) return;

    try {
      await _contentRepository.archivePost(
          postId: post.postId,
          sk: post.sk,
          pk: state.postPk,
          userSlug: appUser.slug,
      );
      if(_onPostRemoved!=null) {
        _onPostRemoved();
      } else {
        emit(state.copyWith(
          archivedBy: Wrapped.value(appUser.userId),
        ));
      }
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(PostStateErrors.archive)));
      _resetError();
    }
  }

  Future<void> restorePost() async {
    final post = state.post;
    if(post.isEmpty) return;

    try {
      final updatedPost = await _contentRepository.restorePost(
        sk: post.sk.startsWith('archived') ? post.sk : 'archived_${post.sk}',
        pk: state.postPk,
      );

      emit(state.copyWith(
        postText: updatedPost.postText,
        reactions: updatedPost.statistics.reactions,
        voteValueSum: updatedPost.statistics.voteValueSum,
        voteCount: updatedPost.statistics.voteCount,
        blurLabel: Wrapped.value(updatedPost.blurLabel),
        archivedBy: const Wrapped.value(null),
      ));
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(PostStateErrors.restore)));
      _resetError();
    }
  }

  void revealPost(){
    emit(state.copyWith(isBlurHidden: const Wrapped.value(false)));
  }

  void _resetError(){
    emit(state.copyWith(error: const Wrapped.value(null)));
  }

  @override
  Future<void> close() {
    log('post cubit disposed: $postId');
    _votesChangesSubscription.cancel();

    if(initialPost!=null) {
      final statePost = state.post;
      if(initialPost!.isNotEqualTo(statePost)) {
        log('${initialPost!.postId} — post != statePost');
        if(_onPostUpdated!=null) _onPostUpdated(statePost);
      }
    }

    return super.close();
  }
}
