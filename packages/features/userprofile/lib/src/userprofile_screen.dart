import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trust/trust.dart';
import 'userprofile_cubit.dart';

class UserprofilePopupScreen extends StatelessWidget {
  const UserprofilePopupScreen({
    required this.contentRepository,
    required this.userRepository,
    required this.userSlug,
    required this.isProduction,
    required this.appUser,
    this.userId,
    this.child,
    super.key,
  }) : assert(child!=null ||userId!=null, 'Either child or userId must be provided.');

  final ContentRepository contentRepository;
  final UserRepository userRepository;
  final String userSlug;
  final bool isProduction;
  final AppUser appUser;
  final String? userId;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final isAppUser = appUser.slug==userSlug;
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
                  create: (context) => UserprofileCubit(
                    contentRepository:contentRepository,
                    slug:userSlug,
                    appUser: appUser,
                  ),
                  child: UserprofilePopupView(
                    isProduction: isProduction,
                    appUser: appUser,
                    isAppUser: isAppUser,
                  )),
            )
        ),
      ];},
      child: child ?? ProfilePictureWidget(
        userId: userId!,
        isProduction: isProduction,
        imageSizeThreshold: userRepository.imageSizeThreshold,
      ),
    );
  }
}

class UserprofilePopupView extends StatelessWidget {
  const UserprofilePopupView({
    required this.isProduction,
    required this.appUser,
    required this.isAppUser,
    super.key,
  });
  final bool isProduction;
  final AppUser appUser;
  final bool isAppUser;

  //TODO: l10n
  String _errorMessage(UserprofileStateErrors error) => switch(error){
    UserprofileStateErrors.load => 'Failed to load the profile',
    UserprofileStateErrors.follow => 'Failed to follow this profile',
    UserprofileStateErrors.unfollow => 'Failed to unfollow this profile',
  };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserprofileCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<UserprofileCubit, UserprofileState>(
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
          child: BlocBuilder<UserprofileCubit, UserprofileState>(
            buildWhen: (p, c) => p.isLoadingProfile!=c.isLoadingProfile || p.userprofile!=c.userprofile,
            builder: (context, state) {
              if(state.isLoadingProfile) {
                return const Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: SizedBox.square(dimension: 40, child: CircularProgressIndicator()),
                );
              }
              final user = state.userprofile;
              if(user==null){
                return GestureDetector(
                  onTap: cubit.refresh,
                  child: const Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: SizedBox.square(dimension: 40, child: Icon(Icons.error)),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(children: [
                      ProfilePictureWidget(userId: user.userId, isProduction: isProduction, allowActions: true, imageSizeThreshold: RepositoryProvider.of<UserRepository>(context).imageSizeThreshold,),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w500),),
                              RichText(text: TextSpan(
                                  style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.w300),
                                  children: [
                                    TextSpan(text: user.trustName),
                                    TextSpan(text: user.membershipType!=null ? ' Patron ' : ' '),
                                    if(user.trustLevel!=null) TextSpan(text: '(${user.trustLevel})'),
                                  ])),
                            ],),
                        ),
                      ),
                      if(appUser.isNotGuest && !isAppUser) Row(children: [
                        const SizedBox(width: 8),
                        BlocBuilder<UserprofileCubit, UserprofileState>(
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
                        if(appUser.canRate && !isAppUser) Row(children: [
                          Text('Set trust boost: ', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
                          SetTrustTooltip(()=>TrustScreen(
                            contentRepository: RepositoryProvider.of<ContentRepository>(context),
                            userSlug: user.slug,
                            appUserTrustLevelInt: appUser.trustLevelInt,
                          )),
                        ],),
                        const Spacer(),
                        TcmTextButton(onTap: () {
                          final createdAt = DateTime.fromMillisecondsSinceEpoch(user.createdAt);
                          final updatedAt = DateTime.fromMillisecondsSinceEpoch(user.updatedAt);
                          showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: const Text('Statistics'),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Tooltip(
                                        message: 'When was the last post or comment created\n${'$updatedAt'.split('.').first}',
                                        child: Text('Updated: ${TimeAgo.timeAgo(updatedAt)}')),
                                    const SizedBox(height: 8,),
                                    Tooltip(
                                        message: '$createdAt'.split('.').first,
                                        child: Text('Joined: ${TimeAgo.timeAgo(createdAt)}')),
                                    if(user.statistics.commentCount!=null) Text('Comments: ${user.statistics.commentCount}'),
                                    if(user.statistics.postCount!=null) Text('Posts: ${user.statistics.postCount}'),
                                    if(user.statistics.totalProfilePosts!=null) Text('Profile posts: ${user.statistics.totalProfilePosts}'),
                                    // if(user.statistics.revisionCount!=null) Text('Revision count: ${user.statistics.revisionCount}'),
                                    if(user.statistics.subwikiCount!=null) Text('Branches created: ${user.statistics.subwikiCount}'),
                                    if(user.statistics.totalFollowers!=null) Text('Followers: ${user.statistics.totalFollowers}'),
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
                    child: SelectionArea(child: Text(user.userBio.trim().isEmpty ? 'I am ${user.fullName}!' : user.userBio)),
                  ),
                  GoToButton(user.slug, isBranch: false, isProduction: isProduction),
                ],
              );
            },),
        ),
      ),
    );
  }
}