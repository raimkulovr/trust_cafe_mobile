import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userprofile/userprofile.dart';

import 'branch_cubit.dart';

class BranchPopupScreen extends StatelessWidget {
  const BranchPopupScreen({
    required this.contentRepository,
    required this.userRepository,
    required this.branchSlug,
    required this.isProduction,
    required this.appUser,
    required this.child,
    super.key,
  });

  final ContentRepository contentRepository;
  final UserRepository userRepository;
  final String branchSlug;
  final bool isProduction;
  final AppUser appUser;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: '',
      splashRadius: 0,
      constraints: const BoxConstraints(maxHeight: 230),
      itemBuilder: (BuildContext context) { return [
        PopupMenuWidget(
            height: 330,
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider.value(value: contentRepository),
                RepositoryProvider.value(value: userRepository),
              ],
              child: BlocProvider(
                  create: (context) => BranchCubit(
                    contentRepository:contentRepository,
                    slug:branchSlug,
                    appUser: appUser,
                  ),
                  child: BranchPopupView(
                    isProduction: isProduction,
                    appUser: appUser,
                  )),
            )
        ),
      ];},
      child: child,
    );
  }
}

class BranchPopupView extends StatelessWidget {
  const BranchPopupView({
    required this.isProduction,
    required this.appUser,
    super.key,
  });

  final bool isProduction;
  final AppUser appUser;

  //TODO: l10n
  String _errorMessage(BranchStateErrors error) => switch(error){
    BranchStateErrors.load => 'Failed to load the branch',
    BranchStateErrors.follow => 'Failed to follow this branch',
    BranchStateErrors.unfollow => 'Failed to unfollow this branch',
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BranchCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<BranchCubit, BranchState>(
      listener: (context, state) {
        if(state.error!=null){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_errorMessage(state.error!)),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: BlocBuilder<BranchCubit, BranchState>(
            buildWhen: (p, c) => p.isLoadingBranch!=c.isLoadingBranch || p.branch!=c.branch,
            builder: (context, state) {
              if(state.isLoadingBranch) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox.square(dimension: 40, child: CircularProgressIndicator()),
                );
              }
              final branch = state.branch;
              if(branch==null){
                return GestureDetector(
                  onTap: cubit.refresh,
                  child: const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: SizedBox.square(dimension: 40, child: Icon(Icons.error)),
                  ),
                );
              }

              final followers = branch.statistics.totalFollowers;
              final posts = branch.statistics.totalPosts;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(children: [
                      Expanded(
                        child: SizedBox(
                          height: 30,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(branch.label, style: const TextStyle(fontWeight: FontWeight.w500),),
                            ),
                          ),
                        ),
                      ),
                      if(appUser.isNotGuest) Row(children: [
                        const SizedBox(width: 8),
                        BlocBuilder<BranchCubit, BranchState>(
                            buildWhen: (p, c) => p.isLoadingSubscriptionData!=c.isLoadingSubscriptionData || p.isFollowing!=c.isFollowing,
                            builder: (context, state) {
                              return state.isLoadingSubscriptionData
                                  ? const SizedBox(
                                      width: 40,
                                      child: LinearProgressIndicator())
                                  : FollowingButton(
                                      isFollowing: state.isFollowing,
                                      onTap: (){
                                        if(state.isFollowing){
                                          cubit.unfollow();
                                        } else {
                                          cubit.follow();
                                        }
                                      }
                                    );
                            }
                        ),
                      ],)
                    ],),
                  ),
                  Divider(color: colorScheme.primary,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,4,0),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text('$posts post${posts>1?'s':''}', style: const TextStyle(fontWeight: FontWeight.w500,),),
                                const SizedBox(width: 8,),
                                Text('$followers member${followers>1?'s':''}', style: const TextStyle(fontWeight: FontWeight.w500,),),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8,),
                        TcmTextButton(onTap: () {
                          final createdAt = DateTime.fromMillisecondsSinceEpoch(branch.createdAt);
                          showDialog(context: context, builder: (dialogcontext) {
                            return AlertDialog(
                              title: Text('Statistics'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if(branch.createdByUser!=null)
                                      Row(children: [
                                        Text('Created by: '),
                                        UserprofilePopupScreen(
                                          contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                          userRepository: RepositoryProvider.of<UserRepository>(context),
                                          userSlug: branch.createdByUser!.slug,
                                          isProduction: isProduction,
                                          appUser: appUser,
                                          child: Text(branch.createdByUser!.fullName,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(decoration: TextDecoration.underline)),
                                        ),
                                      ]),
                                    Tooltip(
                                        message: '$createdAt'.split('.').first,
                                        child: Text('Created: ${TimeAgo.timeAgo(createdAt)}')),
                                    Text('Posts: $posts'),
                                    Text('Members: $followers'),
                                    // if(branch.statistics.authorCount!=null) Text('Author count: ${branch.statistics.authorCount}'),
                                    // if(branch.statistics.revisionCount!=null) Text('Revision count: ${branch.statistics.revisionCount}'),
                                  ],),
                              ),
                            );
                          },);
                        }, text: 'statistics',)
                      ],),
                  ),
                  // Text(user.userBio),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SelectionArea(child: Text(branch.description.trim())),
                  ),
                  GoToButton(branch.slug, isBranch: true, isProduction: isProduction),
                ],
              );
            },),
        ),
      ),
    );
  }
}