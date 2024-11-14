import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:component_library/typedefs.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({
    required this.comment,
    required this.appUser,
    required this.postId,
    required OnCommentUpdatedCallback onCommentUpdated,
    required UserRepository userRepository,
    required ContentRepository contentRepository,
  }) :  _contentRepository = contentRepository,
        _userRepository = userRepository,
        _onCommentUpdated = onCommentUpdated,
        super(CommentState(
          commentText: comment.commentText,
          voteValueSum: comment.statistics.voteValueSum,
          voteCount: comment.statistics.voteCount,
          isUpvoted: contentRepository.isSubjectUpvoted(comment.sk),
          reactions: comment.statistics.reactions,
          blurLabel: comment.blurLabel,
          isBlurHidden: comment.blurLabel!=null,
          isArchivedHidden: comment.archived,
          archived: comment.archived,
      )){
    log('comment cubit created: ${comment.slug}');
    if(!comment.statistics.reactions.isEmpty && appUser.isNotGuest) {
      _getReaction();
    }

    _votesChangesSubscription = contentRepository.userVotesStream().listen((votes) {
      emit(state.copyWith(isUpvoted: Wrapped.value(contentRepository.isSubjectUpvoted(comment.sk))));
    },);
  }

  final AppUser appUser;
  final OnCommentUpdatedCallback _onCommentUpdated;
  final Comment comment;
  final UserRepository _userRepository;
  final ContentRepository _contentRepository;
  final String postId;
  late final StreamSubscription _votesChangesSubscription;

  Future<void> _getReaction() async {
    final cachedReaction = await _contentRepository.getCachedReaction(comment.sk);
    if(!isClosed) emit(state.copyWith(reaction: cachedReaction));

    await Future.delayed(const Duration(seconds: 1, milliseconds: 500), () async {
      if(!isClosed) {
        final networkReaction = await _contentRepository.getNetworkReaction(comment.sk);
        if (!isClosed) emit(state.copyWith(reaction: networkReaction));
      }
    });
  }

  Future<void> castReaction(String reaction) async {
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
        sk: comment.sk,
        pk: comment.pk,
        slug: comment.slug,
        entity: 'comment',
        comment: comment.copyWith(
            statistics: comment.statistics.copyWith(
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
          error: const Wrapped.value(CommentStateErrors.reactionCast)));
      _resetError();
    }
  }

  Future<void> castVote({
    required bool? isUpvote,
  }) async {
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
        sk: comment.sk,
        pk: comment.pk,
        slug: comment.slug,
        userslug: appUser.slug,
        voteValue: voteValue,
        comment: comment.copyWith(
            statistics: comment.statistics.copyWith(
              voteCount: state.voteCount,
              voteValueSum: state.voteValueSum,
              reactions: state.reactions,
            )),
      );
      _votesChangesSubscription.resume();
    } catch(e) {
      emit(state.copyWith(
        isUpvoted: Wrapped.value(isUpvoted),
        error: const Wrapped.value(CommentStateErrors.voteCast),
        voteValueSum: voteSumInitial,
        voteCount: voteCountInitial,
      ));
      _resetError();
    }
  }

  Future<void> translate() async {
    if(state.translation==null){
      try {
        emit(state.copyWith(translationIsProcessing: true));
        final result = await _contentRepository.translateContent(
            itemId: comment.slug, content: state.commentText, targetLocale: _userRepository.getTranslationTarget());
        emit(state.copyWith(
            translation: Wrapped.value('Translated from ${result.from}:\n${result.translation}'),
            translationIsProcessing: false,
        ),
        );
      } catch(e){
        emit(state.copyWith(error: const Wrapped.value(CommentStateErrors.translation), translationIsProcessing: false));
        _resetError();
      }
    } else {
      emit(state.copyWith(translation: const Wrapped.value(null)));
    }
  }

  Future<void> editCommentText(String newCommentText, String? blurLabel) async {
    final initialCommentText = state.commentText;
    final initialBlurLabel = state.blurLabel;
    emit(state.copyWith(
        commentText: newCommentText,
        blurLabel: Wrapped.value(blurLabel),
        isBlurHidden: state.blurLabel==null && blurLabel!=null));
    try{
      final result = await _contentRepository.updateComment(
        keySk: comment.sk,
        keyPk: comment.pk,
        keySlug: comment.slug,
        commentText: newCommentText,
        blurLabel: blurLabel,
      );
      emit(state.copyWith(
          commentText: result.commentText,
          reactions: result.statistics.reactions,
          voteValueSum: result.statistics.voteValueSum,
          voteCount: result.statistics.voteCount,
          blurLabel: Wrapped.value(result.blurLabel),
      ));
    } catch (e){
      log('editCommentText error: $e');
      emit(state.copyWith(commentText: initialCommentText, blurLabel: Wrapped.value(initialBlurLabel),
          error: const Wrapped.value(CommentStateErrors.edit)));
      _resetError();
    }
  }

  Future<void> archiveComment() async {
    try {
      final updatedComment = await _contentRepository.archiveComment(
          postId: postId,
          sk: comment.sk,
          pk: comment.pk,
          userSlug: appUser.slug);
      emit(state.copyWith(
        commentText: updatedComment.commentText,
        reactions: updatedComment.statistics.reactions,
        voteValueSum: updatedComment.statistics.voteValueSum,
        voteCount: updatedComment.statistics.voteCount,
        blurLabel: Wrapped.value(updatedComment.blurLabel),
        archived: updatedComment.archived,
      ));
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(CommentStateErrors.archive)));
      _resetError();
    }
  }

  Future<void> restoreComment() async {
    try {
      final updatedComment = await _contentRepository.restoreComment(
        postId: postId,
        sk: 'archived_${comment.sk}',
        pk: comment.pk,
      );
      emit(state.copyWith(
        commentText: updatedComment.commentText,
        reactions: updatedComment.statistics.reactions,
        voteValueSum: updatedComment.statistics.voteValueSum,
        voteCount: updatedComment.statistics.voteCount,
        blurLabel: Wrapped.value(updatedComment.blurLabel),
        archived: updatedComment.archived,
      ));
    } catch (e) {
      emit(state.copyWith(error: const Wrapped.value(CommentStateErrors.restore)));
      _resetError();
    }
  }

  void revealComment({required bool blur}){
    emit(state.copyWith(
      isBlurHidden: blur ? false: null,
      isArchivedHidden: blur ? null: false,
    ));
  }

  void _resetError(){
    emit(state.copyWith(error: const Wrapped.value(null)));
  }

  @override
  Future<void> close() {
    log('comment cubit disposed: ${comment.slug}');
    _votesChangesSubscription.cancel();
    final stateComment = state.getCommentRepresentation(comment);
    if(comment.isNotEqualTo(stateComment)) {
      log('${comment.slug} — comment != stateComment');
      _onCommentUpdated(stateComment);
    }
    return super.close();
  }
}
