import 'dart:developer';
import 'package:trust_cafe_mobile/features/comments/comments.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:trust_cafe_mobile/features/spider/spider.dart';
import 'package:user_repository/user_repository.dart';

import 'widgets/widgets.dart';
import 'post_cubit.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({
    required this.post,
    required this.postId,
    required this.userRepository,
    required this.contentRepository,
    required this.appUser,
    this.onPostUpdated,
    this.onPostRemoved,
    this.scrollToSlug,
    this.isScrollingUp = false,
    super.key,
  })  :  assert(post!=null || postId!=null, 'Either post or postId must be provided');

  final Post? post;
  final String? postId;
  final AppUser appUser;
  final UserRepository userRepository;
  final ContentRepository contentRepository;
  final OnPostUpdatedCallback? onPostUpdated;
  final VoidCallback? onPostRemoved;
  final String? scrollToSlug;
  final bool isScrollingUp;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PostCallbackProvider(
      getAppUser: () => appUser,
      scrollToSlug: () => scrollToSlug,
      showComments:  (post, {shouldScrollToSlug = false}) => CommentsScreen.showComments(
          context: context,
          post: post,
          backgroundColor: colorScheme.surface,
          contentRepository: contentRepository,
          userRepository: userRepository,
          scrollToSlug: shouldScrollToSlug ? scrollToSlug : null,
      ),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: contentRepository),
        ],
        child: BlocProvider<PostCubit>(
            create: (context) => PostCubit(
              initialPost: post,
              postId: postId,
              appUser: appUser,
              onPostUpdated: onPostUpdated,
              userRepository: userRepository,
              contentRepository: contentRepository,
              onPostRemoved: onPostRemoved,
            ),
            child: post==null
                ? FullScreenPostView()
                : PostView(
                    isScrollingUp: isScrollingUp,
                    isFullScreen: false,
                  )
        ),
      ),
    );
  }
}

class FullScreenPostView extends StatelessWidget {
  const FullScreenPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: RefreshIndicator(
          onRefresh: () async {
            context.read<PostCubit>().refreshPost();
          },
          child: ListView(
            children: [
              PostView(
                isScrollingUp: false,
                isFullScreen: true,
              )
            ],
          )
      ),
    );
  }
}


class PostView extends StatelessWidget {
  const PostView({
    required this.isScrollingUp,
    required this.isFullScreen,
    super.key});

  final bool isScrollingUp;
  final bool isFullScreen;

  //TODO: l10n
  String _errorMessage(PostStateErrors error) => switch(error){
    PostStateErrors.translation => 'Failed to translate',
    PostStateErrors.voteCast => 'Failed to cast a vote',
    PostStateErrors.movement => 'Failed to move the post',
    PostStateErrors.edit => 'Failed to edit the post',
    PostStateErrors.reactionCast => 'Failed to cast a reaction',
    PostStateErrors.archive => 'Failed to archive the post',
    PostStateErrors.restore => 'Failed to restore the post',
    PostStateErrors.load => 'Failed to load the post',
  };

  @override
  Widget build(BuildContext context) {
    bool showedComments = false;
    final cubit = context.read<PostCubit>();
    final scrollToSlug = PostCallbackProvider.of(context).scrollToSlug();
    return BlocListener<PostCubit, PostState>(
      listenWhen: (p, c) =>cubit.initialPost==null && c.post.isNotEmpty && !c.post.isNotFound,
      listener: (context, state) {
        //The post has just been loaded with an available Comment Slug and is not archived, so comments are displayed
        if(!showedComments && scrollToSlug!=null && !state.post.isNotFound && state.post.isNotEmpty && !state.post.isArchived){
          PostCallbackProvider.of(context).showComments(state.post, shouldScrollToSlug: true);
          showedComments = true;
        }
      },
      child: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if(state.error!=null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_errorMessage(state.error!)),
              ),
            );
          }
        },
        buildWhen: (p, c) => p.post.isEmpty && c.post.isNotEmpty ||
            p.post.isNotFound && !c.post.isNotFound ||
            p.archived!=c.archived,
        builder: (context, state) {
          final post = state.post;
          if(post.isEmpty){
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if(post.isNotFound){
            return const EntityNotFound();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostHeader(post),
              if(state.archived)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: Text('ARCHIVED', style: TextStyle(color: Colors.red),)),
                ),
              BlocBuilder<PostCubit, PostState>(
                  buildWhen: (p, c) => p.translation!=c.translation,
                  builder: (context, state) {
                    return (state.translation!=null)
                        ? Container(
                          color: Colors.lightBlueAccent.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(state.translation.toString()),
                        )
                        : const SizedBox();
                  },
              ),
              BlocBuilder<PostCubit, PostState>(
                buildWhen: (p, c) => p.isBlurHidden!=c.isBlurHidden || p.blurLabel!=c.blurLabel,
                builder: (context, state) {
                  if(state.blurLabel!=null && (state.isBlurHidden ?? true)){
                    return TcmShowMarkedContentButton(
                        blurLabel: state.blurLabel!,
                        onTap: context.read<PostCubit>().revealPost);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<PostCubit, PostState>(
                          buildWhen: (p, c) => p.postText!=c.postText,
                          builder: (context, state) {
                            return ExpandableHtmlWidget(
                              key: ValueKey(state.hashCode),
                              html: state.postText,
                              imageSizeThreshold: RepositoryProvider.of<UserRepository>(context).imageSizeThreshold,
                              isExpanded: isFullScreen,
                            );
                          }
                      ),
                      BlocBuilder<PostCubit, PostState>(
                          buildWhen: (p, c) => p.cardUrl!=c.cardUrl,
                          builder: (context, state) {
                            return state.cardUrl.isNotEmpty
                                ? SpiderScreen(
                                    key: ValueKey(state.cardUrl),
                                    url: state.cardUrl,
                                    initialHide: isScrollingUp,
                                    contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                    userRepository: RepositoryProvider.of<UserRepository>(context),
                                  )
                                : const SizedBox();
                          }
                      ),
                    ],
                  );
              },),
              BlocBuilder<PostCubit, PostState>(
                  buildWhen: (p, c) => p.reaction!=c.reaction || p.reactions!=c.reactions,
                  builder: (context, state) {
                    return ReactionsListWidget(state.reactions,
                      selectedReaction: state.reaction,
                      onReaction: PostCallbackProvider.of(context).getAppUser().isNotGuest && !post.isArchived
                          ? context.read<PostCubit>().castReaction
                          : null,
                    );
                  }
              ),
              PostBottom(post),
            ],
          );
        }
      ),
    );
  }
}
