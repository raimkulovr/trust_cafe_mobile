import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_editor/text_editor.dart';
import 'package:trust_cafe_mobile/features/trust/trust.dart';
import 'package:user_repository/user_repository.dart';
import 'package:trust_cafe_mobile/features/userprofile/userprofile.dart';

import '../comment_cubit.dart';
import 'comment_callback_provider.dart';

class CommentHeader extends StatelessWidget {
  const CommentHeader(this.comment, {
    this.horizontalPadding = 8,
    super.key,
  });

  final Comment comment;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final appUser = CommentCallbackProvider.of(context).getAppUser();
    final author = comment.data.createdByUser;
    final cubit = context.read<CommentCubit>();
    return Padding(
      padding: EdgeInsets.only(top: 2, left: horizontalPadding),
      child: Row(
        children: [
          UserprofilePopupScreen(
            contentRepository: RepositoryProvider.of<ContentRepository>(context),
            userRepository: RepositoryProvider.of<UserRepository>(context),
            userId: author.userId,
            userSlug: author.slug,
            isProduction: RepositoryProvider.of<UserRepository>(context).isApiChannelProduction(),
            appUser: CommentCallbackProvider.of(context).getAppUser(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(author.fullName, style: const TextStyle(fontWeight: FontWeight.bold),),
                      if(appUser.userId != author.userId)
                        Row(children: [
                          if(author.trustName!=null || appUser.canRate) const Text(' (', style: TextStyle(fontWeight: FontWeight.w300),),
                          if(author.trustName!=null) Text('${author.trustName}${author.membershipType!=null?' Patron':''}', style: const TextStyle(fontWeight: FontWeight.w300),),
                          if(appUser.canRate)
                            SetTrustTooltip(()=>TrustScreen(
                              userSlug: author.slug,
                              appUserTrustLevelInt: appUser.trustLevelInt,
                              contentRepository: RepositoryProvider.of<ContentRepository>(context),
                            )),
                          if(author.trustName!=null || appUser.canRate) const Text(')', style: TextStyle(fontWeight: FontWeight.w300),),
                        ],),
                      const Text(' - ', style: TextStyle(fontWeight: FontWeight.w300),),
                      TimeAgo(DateTime.fromMillisecondsSinceEpoch(comment.createdAt)),
                    ],),
                  if(comment.data.comment!=null && comment.data.comment!.createdByUser!=null)
                    GestureDetector(
                        onTap: CommentCallbackProvider.of(context).onParentAuthorPressed,
                        child: Text('replied to ${comment.data.comment!.createdByUser!.fullName}'))
                ],
              ),
            ),
          ),
          BlocBuilder<CommentCubit, CommentState>(
              buildWhen: (p, c) =>
                p.commentText!=c.commentText ||
                p.translationIsProcessing!=c.translationIsProcessing ||
                p.commentText!=c.commentText ||
                p.blurLabel!=c.blurLabel ||
                p.archived!=c.archived ||
                p.commentText!=c.commentText,
              builder: (context, state) {
                return PopupMenuButton<void Function()>(
                  itemBuilder: (popupcontext) {
                    return [
                      PopupMenuItem(
                        enabled: !state.translationIsProcessing,
                        value: () => context.read<CommentCubit>().translate(),
                        child: const PopUpMenuTranslate(),
                      ),
                      CopyPopupMenuItem(state.commentText),
                      PopupMenuItem(
                        enabled: !state.translationIsProcessing,
                        value: () => CopyManager.copy('https://${RepositoryProvider.of<UserRepository>(context).isApiChannelProduction() ? 'www.trustcafe.io' : 'alpha.wts2.net'}/en/post/${comment.topLevel.slug}#comment-${comment.slug}', type: CopyManagerType.text),
                        child: const Text('Copy link to this comment'),
                      ),
                      if(!comment.archived && comment.data.createdByUser.userId == appUser.userId)
                        PopupMenuItem(
                          enabled: !comment.archived,
                          value: () async {
                            final updatedComment = await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) =>
                                    TextEditorScreen(
                                      contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                      userRepository: RepositoryProvider.of<UserRepository>(context),
                                      isEditing: true,
                                      initialText: state.commentText,
                                      destination: TextEditorDestination.comment,
                                      blurLabel: state.blurLabel,
                                      canChangeIsCollaborative: false,
                                    )
                                ));
                            if(updatedComment is ({String commentText, String? blurLabel}) && updatedComment.commentText.isNotEmpty){
                              cubit.editCommentText(updatedComment.commentText, updatedComment.blurLabel);
                            }

                          },
                          child: const Text('Edit'),
                        ),
                      // TODO: Deal with archivedBy fetch and all the other moderation nuances.
                      if(comment.data.createdByUser.userId == appUser.userId || appUser.trustLevelInt>=3)
                        PopupMenuItem(
                          child: state.archived
                              ? const Text('Restore')
                              : const Text('Archive', style: TextStyle(color: Colors.red)),
                          value: () => state.archived
                              ? cubit.restoreComment()
                              : showDialog(
                            context: context,
                            builder: (dialogContext) => ArchiveDialog(
                              type: ArchiveType.comment,
                              contentText: state.commentText,
                              author: author,
                              onArchive: cubit.archiveComment,
                              imageSizeThreshold: RepositoryProvider.of<UserRepository>(context).imageSizeThreshold,
                            ),
                          ),
                        ),
                    ];
                  },
                  onSelected: (fn) => fn(),
                );
              }
          )
        ],
      ),
    );
  }
}