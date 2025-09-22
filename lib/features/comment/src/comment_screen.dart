import 'package:flutter/material.dart';

import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'comment_cubit.dart';
import 'widgets/widgets.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen(this.comment, {
    required this.userRepository,
    required this.contentRepository,
    required this.onCommentUpdated,
    required this.onCommentReplied,
    required this.appUser,
    required this.onParentAuthorPressed,
    required this.postId,
    super.key,
  });

  final AppUser appUser;
  final Comment comment;
  final UserRepository userRepository;
  final ContentRepository contentRepository;
  final OnCommentUpdatedCallback onCommentUpdated;
  final OnCommentRepliedCallback onCommentReplied;
  final VoidCallback? onParentAuthorPressed;
  final String postId;

  @override
  Widget build(BuildContext context) {
    return CommentCallbackProvider(
      getAppUser: () => appUser,
      onCommentReplied: onCommentReplied,
      onParentAuthorPressed: onParentAuthorPressed,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: contentRepository),
        ],
        child: BlocProvider<CommentCubit>(
          create: (context) => CommentCubit(
              comment: comment,
              appUser: appUser,
              onCommentUpdated: onCommentUpdated,
              userRepository: userRepository,
              contentRepository: contentRepository,
              postId: postId,
          ),
          child: CommentView(comment)
        ),
      ),
    );
  }
}

class CommentView extends StatelessWidget {
  const CommentView(this.comment, {super.key});

  final Comment comment;

  //TODO: l10n
  String _errorMessage(CommentStateErrors error) => switch(error){
    CommentStateErrors.translation => 'Failed to translate',
    CommentStateErrors.voteCast => 'Failed to cast a vote',
    CommentStateErrors.edit => 'Failed to edit the comment',
    CommentStateErrors.reactionCast => 'Failed to cast a reaction',
    CommentStateErrors.archive => 'Failed to archive the comment',
    CommentStateErrors.restore => 'Failed to restore the comment',
  };

  @override
  Widget build(BuildContext context) {
    return comment.deleted
        ? const Center(child: Text('This comment has been deleted', style: TextStyle(color: Colors.red),))
        : BlocConsumer<CommentCubit, CommentState>(
            listener: (context, state) {
              if(state.error!=null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_errorMessage(state.error!)),
                  ),
                );
              }
            },
            buildWhen: (p, c) => p.isArchivedHidden!=c.isArchivedHidden || p.archived!=c.archived,
            builder: (context, state) {
              return state.isArchivedHidden
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          Text('${comment.data.createdByUser.fullName} - comment has been archived.'),
                          TextButton(onPressed: () => context.read<CommentCubit>().revealComment(blur: false), child: Text('Show')),
                        ],),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommentHeader(comment),
                        if(state.archived)
                          const Center(child: Text('ARCHIVED', style: TextStyle(color: Colors.red),)),
                        BlocBuilder<CommentCubit, CommentState>(
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
                        BlocBuilder<CommentCubit, CommentState>(
                            buildWhen: (p, c) => p.isBlurHidden!=c.isBlurHidden || p.blurLabel!=c.blurLabel,
                            builder: (context, state) {
                              if(state.blurLabel!=null && state.isBlurHidden){
                                return TcmShowMarkedContentButton(
                                    isPost: false,
                                    blurLabel: state.blurLabel!,
                                    onTap: ()=>context.read<CommentCubit>().revealComment(blur: true));
                              }

                              return BlocBuilder<CommentCubit, CommentState>(
                                  buildWhen: (p, c) => p.commentText!=c.commentText,
                                  builder: (context, state) {
                                    return ExpandableHtmlWidget(key: ValueKey(state.hashCode), html: state.commentText,
                                      imageSizeThreshold: RepositoryProvider.of<UserRepository>(context).imageSizeThreshold,);
                                  });
                            }
                        ),
                        if(!state.archived) BlocBuilder<CommentCubit, CommentState>(
                            buildWhen: (p, c) => p.reaction!=c.reaction || p.reactions!=c.reactions,
                            builder: (context, state) {
                              return ReactionsListWidget(state.reactions,
                                selectedReaction: state.reaction,
                                onReaction: CommentCallbackProvider.of(context).getAppUser().isNotGuest ? context.read<CommentCubit>().castReaction : null,
                              );
                            }
                        ),
                        if(!state.archived) CommentBottom(comment),
                      ],
                    );
            },
          );
  }
}
