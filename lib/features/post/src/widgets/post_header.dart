import 'dart:developer';

import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:text_editor/text_editor.dart';
import 'package:trust_cafe_mobile/features/trust/trust.dart';
import 'package:user_repository/user_repository.dart';
import 'package:trust_cafe_mobile/features/userprofile/userprofile.dart';
import 'package:trust_cafe_mobile/features/branch/branch.dart';

import '../post_cubit.dart';
import 'widgets.dart';


class PostHeader extends StatelessWidget {
  const PostHeader(this.post, {
    this.horizontalPadding = 8,
    super.key,
  });

  final Post post;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final appUser = PostCallbackProvider.of(context).getAppUser();
    final postAuthor = post.data.createdByUser;
    final isCreatedByAppUser = postAuthor.userId == appUser.userId;

    final cubit = context.read<PostCubit>();
    return Container(
      padding: EdgeInsets.only(top: 2, bottom:2, left: horizontalPadding),
      decoration: BoxDecoration(
        color: colorScheme.brightness==Brightness.light ? Colors.white60 : TcmColors.darkAppBarColor,
        boxShadow: [
          if(colorScheme.brightness==Brightness.light)
            BoxShadow(
              color: colorScheme.onSurface.withOpacity(0.3),
              blurRadius: 1,
              spreadRadius: 1,
              offset: Offset(0, 1.7),
            ),
        ],
      ),
      child: Row(
        children: [
          UserprofilePopupScreen(
            contentRepository: RepositoryProvider.of<ContentRepository>(context),
            userId: postAuthor.userId,
            userSlug: postAuthor.slug,
            isProduction: RepositoryProvider.of<UserRepository>(context).isApiChannelProduction(),
            appUser: PostCallbackProvider.of(context).getAppUser(),
            userRepository: RepositoryProvider.of<UserRepository>(context),
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
                      Text(postAuthor.fullName, style: const TextStyle(fontWeight: FontWeight.bold),),
                      if(postAuthor.trustName!=null || appUser.canRate) Text(' (${postAuthor.trustName ?? (postAuthor.userId==appUser.userId ? appUser.trustLevelInfo : '')}${postAuthor.membershipType!=null?' Patron':''}', style: const TextStyle(fontWeight: FontWeight.w300),),
                      if(appUser.isNotGuest && appUser.canRate && appUser.userId != postAuthor.userId)
                        SetTrustTooltip(()=>TrustScreen(
                          userSlug: postAuthor.slug,
                          appUserTrustLevelInt: appUser.trustLevelInt,
                          contentRepository: RepositoryProvider.of<ContentRepository>(context),
                        )),
                      if(postAuthor.trustName!=null || appUser.canRate) const Text(')', style: TextStyle(fontWeight: FontWeight.w300),),

                      const Text(' - ', style: TextStyle(fontWeight: FontWeight.w300),),
                      TimeAgo(DateTime.fromMillisecondsSinceEpoch(post.createdAt)),
                    ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('posted in ',),
                      BlocBuilder<PostCubit, PostState>(
                          buildWhen: (p, c) => p.postData!=c.postData,
                          builder: (context, state) {
                            final postData = state.postData;
                            if(postData.maintrunk!=null) {
                              return Stack(children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(68, 119, 40, 1),
                                  ),
                                  child: RichText(text: TextSpan(
                                      style: TextStyle(color: Colors.transparent),
                                      children: [
                                        WidgetSpan(child: TrunkIcon(color: Colors.transparent,), alignment: PlaceholderAlignment.middle),
                                        TextSpan(text: postData.maintrunk.toString(),
                                          style: TextStyle(color: Colors.transparent, fontStyle: FontStyle.italic),),
                                      ])),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  child: RichText(text: TextSpan(children: [
                                    WidgetSpan(child: TrunkIcon(), alignment: PlaceholderAlignment.middle),
                                    TextSpan(text: postData.maintrunk.toString(),
                                      style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),),
                                  ])),
                                ),
                              ],);
                            }
                            if(postData.subwiki!=null && postData.subwiki!.isValid) {
                              return BranchPopupScreen(
                                contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                userRepository: RepositoryProvider.of<UserRepository>(context),
                                branchSlug: postData.subwiki!.slug!,
                                isProduction: RepositoryProvider.of<UserRepository>(context).isApiChannelProduction(),
                                appUser: PostCallbackProvider.of(context).getAppUser(),
                                child: Text(postData.subwiki!.label!,
                                    style: TextStyle(decoration: TextDecoration.underline)),
                              );
                            }

                            final isPostedInTheirBranch = postData.userprofile?.fullName==postData.createdByUser.fullName;
                            if(isPostedInTheirBranch){
                              return Text('their branch');
                            } else {
                              if(postData.userprofile==null || !postData.userprofile!.isValid) return SizedBox();
                              return UserprofilePopupScreen(
                                contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                userRepository: RepositoryProvider.of<UserRepository>(context),
                                userSlug: postData.userprofile!.slug!,
                                isProduction: RepositoryProvider.of<UserRepository>(context).isApiChannelProduction(),
                                appUser: PostCallbackProvider.of(context).getAppUser(),
                                child: Text('${postData.userprofile!.fullName}\'s branch',
                                    style: TextStyle(decoration: TextDecoration.underline)),
                              );
                            }
                          }
                      ),
                      BlocBuilder<PostCubit, PostState>(
                          buildWhen: (p, c) => p.collaborative!=c.collaborative,
                          builder: (context, state) {
                            return Text(' - ${state.collaborative ? 'collaborative' : 'personal'} post',
                                style: const TextStyle(fontWeight: FontWeight.w300, fontStyle: FontStyle.italic));
                          }
                      ),
                    ],),
                ],
              ),
            ),
          ),
          // const Spacer(),
          BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                final appUser = PostCallbackProvider.of(context).getAppUser();
                return PopupMenuButton<void Function()>(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        enabled: !state.translationIsProcessing,
                        value: () => context.read<PostCubit>().translate(),
                        child: const PopUpMenuTranslate(),
                      ),
                      CopyPopupMenuItem(state.postText),
                      PopupMenuItem(
                        value: () => CopyManager.copy('https://${RepositoryProvider.of<UserRepository>(context).isApiChannelProduction() ? 'www.trustcafe.io' : 'alpha.wts2.net'}/en/post/${post.postId}', type: CopyManagerType.text),
                        child: const Text('Copy link to this post'),
                      ),
                      if(!post.isArchived && (isCreatedByAppUser || appUser.trustLevelInt>=3))
                        PopupMenuItem(
                          value: () => showDialog(
                            context: context,
                            useRootNavigator: true,
                            builder: (dialogContext) => RepositoryProvider.value(
                              value: RepositoryProvider.of<ContentRepository>(context),
                              child: BlocProvider.value(
                                value: context.read<PostCubit>(),
                                child: MoveToAlertDialog(
                                  canMoveToProfile: state.postData.userprofile?.slug != state.postData.createdByUser.slug,
                                ),),
                            ),
                          ),
                          child: Text('Move to…'),
                        ),
                      if(!post.isArchived && appUser.isNotGuest &&
                          (isCreatedByAppUser ||
                              (state.collaborative && appUser.trustLevelInt>=1) ||
                              appUser.isAdmin))
                        PopupMenuItem(
                          value: () async {
                            final updatedPost = await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) =>
                                    TextEditorScreen(
                                      contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                      userRepository: RepositoryProvider.of<UserRepository>(context),
                                      isEditing: true,
                                      initialText: state.postText,
                                      collaborative: state.collaborative,
                                      cardUrl: state.cardUrl,
                                      canChangeIsCollaborative: state.postData.createdByUser.slug == appUser.slug || appUser.isAdmin,
                                      destination: TextEditorDestination.post,
                                      blurLabel: state.blurLabel,
                                    )
                                ));
                            log('got updated post: $updatedPost');
                            if (updatedPost is ({
                              String postText,
                              bool collaborative,
                              String cardUrl,
                              String? blurLabel,}))
                            {
                              cubit.editPost(updatedPost);
                            }
                          },
                          child: const Text('Edit'),
                        ),
                      if(!isCreatedByAppUser)
                        PopupMenuItem(
                          value: () => state.postData.subwiki!=null && state.postData.subwiki!.isValid
                              ? showDialog(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (dialogContext) => RepositoryProvider.value(
                                    value: RepositoryProvider.of<UserRepository>(context),
                                    child: IgnoreAlertDialog(
                                      authorSlug: postAuthor.slug,
                                      branchSlug: state.postData.subwiki!.slug!,
                                    ),
                                  ),
                                )
                              : RepositoryProvider.of<UserRepository>(context).modifyIgnoreList(postAuthor.slug, isUser: true, add: true),
                          child: Text('Ignore${state.postData.subwiki!=null && state.postData.subwiki!.isValid? '…' : ' this user'}'),
                        ),
                      if(isCreatedByAppUser || appUser.trustLevelInt>=3)
                        PopupMenuItem(
                          child: state.archived
                              ? const Text('Restore')
                              : const Text('Archive', style: TextStyle(color: Colors.red),), //TODO: l10n
                          value: () => state.archived
                              ? cubit.restorePost()
                              : showDialog(
                                  context: context,
                                  useRootNavigator: true,
                                  builder: (dialogContext) => ArchiveDialog(
                                    type: ArchiveType.post,
                                    contentText: state.postText,
                                    author: state.post.data.createdByUser,
                                    onArchive: cubit.archivePost,
                                    imageSizeThreshold: RepositoryProvider.of<UserRepository>(context).imageSizeThreshold,
                                  ),
                                ),
                        ),
                    ];
                  },
                  onSelected: (fn) => fn(),
                );
              }
          ),
        ],
      ),
    );
  }
}
