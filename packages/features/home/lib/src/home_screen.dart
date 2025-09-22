import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:trust_cafe_mobile/features/feed/feed.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/src/home_bloc.dart';
import 'package:rxdart/rxdart.dart' hide Notification;
import 'package:text_editor/text_editor.dart';
import 'package:user_repository/user_repository.dart';

import 'widgets/notification_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.userRepository,
    required this.contentRepository,
    required this.onAuthenticationRequest,
    required this.appUser,
    super.key,
  });

  final AppUser appUser;
  final UserRepository userRepository;
  final ContentRepository contentRepository;
  final OnAuthenticationRequestedCallback onAuthenticationRequest;

  @override
  Widget build(BuildContext context) {
    return _CallbackProvider(
      getAppUser: ()=>appUser,
      onAuthenticationRequest: onAuthenticationRequest,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: contentRepository),
        ],
        child: BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(
              contentRepository: contentRepository,
              userRepository: userRepository,
              appUser: appUser,
          ),
          child: const HomeView(),
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeBloc get _bloc => context.read<HomeBloc>();
  final BehaviorSubject<FeedType> currentTabBarBehaviorSubject = BehaviorSubject();
  final BehaviorSubject<Post> newPostsBehaviorSubject = BehaviorSubject();
  late final ValueNotifier<int> currentTabBarIndex;

  @override
  void initState() {
    currentTabBarIndex = ValueNotifier<int>(0);
    cacheScrollDirection = ScrollDirection.reverse;
    super.initState();
  }

  void _resetScrollPosition() {
    currentTabBarBehaviorSubject.add(switch(currentTabBarIndex.value){0=>FeedType.forYou, _=>FeedType.yourFeed});
  }

  void _updateCurrentTabBarIndex(int newValue){
    currentTabBarIndex.value = newValue;
  }

  late ScrollDirection cacheScrollDirection;


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appUser = _CallbackProvider.of(context).getAppUser();
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if(state.newPost!=null){
          newPostsBehaviorSubject.add(state.newPost!);
          _bloc.add(const HomePostRegistered());
        }
        if (state.createNewPostError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                //TODO: replace with l10n
                  'Failed to create a post'
              ),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (p, c) => p.creatingNewPost!=c.creatingNewPost || p.notifications!=c.notifications || p.isReloadingNotifications!=c.isReloadingNotifications,
            builder: (context, state) {
              final isProduction = RepositoryProvider.of<UserRepository>(context).isApiChannelProduction();
              return AppBar(
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                forceMaterialTransparency: true,
                title: GestureDetector(
                    onTap: _resetScrollPosition,
                    child: const ReducedLogoBrown()),
                actions: [
                  if(appUser.isNotGuest) Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(children: [
                      state.creatingNewPost ? CircularProgressIndicator() : InkWell(
                        onTap: () async {
                          final newPost = await Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) =>
                                  TextEditorScreen(
                                    contentRepository: RepositoryProvider.of<ContentRepository>(context),
                                    userRepository: RepositoryProvider.of<UserRepository>(context),
                                    canChangeIsCollaborative: true,
                                    isEditing: false,
                                    profileSlug: currentTabBarIndex.value>0 ? appUser.slug : null,
                                    destination: TextEditorDestination.post,
                                  ),
                              ));
                          if (newPost is ({
                                String postText,
                                bool collaborative,
                                String cardUrl,
                                String parentSk,
                                String parentPk,
                                String? blurLabel,
                              }) && newPost.postText.isNotEmpty)
                          {
                            _bloc.add(HomePostCreated(
                                postText: newPost.postText,
                                collaborative: newPost.collaborative,
                                cardUrl: newPost.cardUrl,
                                parentSk: newPost.parentSk,
                                parentPk: newPost.parentPk,
                                blurLabel: newPost.blurLabel,
                            )
                            );
                          }
                        },
                        child: Ink(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          height: 40,
                          color: Color.fromRGBO(51, 199, 38, 1),
                          child: Icon(Icons.add, color: Colors.white,),
                        ),
                      ),
                      const SizedBox(width: 8,),
                      state.isReloadingNotifications
                          ? const SizedBox(
                              height: 45.5,
                              width: 45.5,
                              child: Center(
                                child: SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator()),
                              ))
                          : PopupMenuButton(
                              constraints: BoxConstraints(maxHeight: 400),
                              tooltip: 'Show notifications',
                              itemBuilder: (BuildContext context) {
                                final imageSizeThreshold = RepositoryProvider.of<UserRepository>(context).imageSizeThreshold;
                                return [
                                  PopupMenuItem(
                                      enabled: false,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(child: Text('Notifications', style: TextStyle(color: colorScheme.onSurface),)),
                                              IconButton(
                                                  onPressed: () {
                                                    _bloc.add(const HomeNotificationsRefreshed());
                                                    Navigator.of(context).pop();
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  icon: Icon(Icons.refresh, color: colorScheme.onSurface)
                                              )
                                            ],),
                                          const Divider(),
                                        ],
                                      )),
                                // const PopupMenuItem(
                                //     enabled: false,
                                //     child: NotificationWidget(Notification(createdAt: 0, updatedAt: 0, sk: '', pk: '', item: NotificationItem(initiator: Author.system, read: false, reason: 'rank_up', replacements: NotificationItemReplacements(newLevel: 'Double Diamond'))), isProduction: true)),
                                  ...state.notifications.map((Notification e) => PopupMenuItem(
                                      //TODO: navigate to trust booster; ignore for rankup
                                      enabled: !(e.isTrustBoost || e.isRankUp),
                                      onTap: (){
                                        final replacements = e.item.replacements;
                                        final link = replacements.postLink ?? replacements.commentLink;
                                        if(link!=null){
                                          UrlLauncher.launchWebUrl(context, link);
                                        }
                                      },
                                      child: NotificationWidget(e, isProduction: isProduction, imageSizeThreshold: imageSizeThreshold,)))
                                ];
                              },
                              onOpened: () {
                                //TODO: call notifications has been read event
                              },
                              child: Container(
                                  height: 40,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: BellIcon(state.unreadNotifications)),
                            )
                    ],),
                  )
                ],
              );
            },
          ),
        ),
        body: appUser.isGuest
            ? Column(
                children: [
                  LoginPrompt(
                    onAuthenticationRequest: _CallbackProvider.of(context).onAuthenticationRequest,
                  ),
                  Expanded(
                    child: FeedScreen(
                      appUser: appUser,
                      feedType: FeedType.forYou,
                      scrollPositionResetManager: currentTabBarBehaviorSubject.stream,
                      contentRepository: RepositoryProvider.of<ContentRepository>(context),
                      userRepository: RepositoryProvider.of<UserRepository>(context),
                      feedSlugData: null,
                    ),
                  ),
                ],)
            : HomeTabBarView(
                onTabBarIndexChanged: _updateCurrentTabBarIndex,
                feedBuilder: (feedType) => FeedScreen(
                  appUser: appUser,
                  feedType: feedType,
                  scrollPositionResetManager: currentTabBarBehaviorSubject.stream,
                  newPostStream: newPostsBehaviorSubject.stream,
                  contentRepository: RepositoryProvider.of<ContentRepository>(context),
                  userRepository: RepositoryProvider.of<UserRepository>(context),
                  feedSlugData: null,
                ),
              ),
        ),

    );
  }

  @override
  void dispose() {
    currentTabBarIndex.dispose();
    currentTabBarBehaviorSubject.close();
    newPostsBehaviorSubject.close();
    super.dispose();
  }
}

class HomeTabBarView extends StatefulWidget {
  const HomeTabBarView({
    required this.feedBuilder,
    required this.onTabBarIndexChanged,
    super.key,
  });

  final Widget Function(FeedType feedType) feedBuilder;
  final void Function(int) onTabBarIndexChanged;

  @override
  State<HomeTabBarView> createState() => _HomeTabBarViewState();
}

class _HomeTabBarViewState extends State<HomeTabBarView> with SingleTickerProviderStateMixin
{
  late final TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_updateValueNotifier);
    super.initState();
  }

  void _updateValueNotifier(){
    widget.onTabBarIndexChanged(tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(children: [
      TabBar(
        // unselectedLabelColor: Colors.black,
        // labelColor: Colors.red,
        tabs: const [
          Tab(
            text: 'For You',
          ),
          Tab(
            text: 'Your Feed',
          ),
        ],
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
      Expanded(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            AutomaticKeepAliveFeedBuilder(widget.feedBuilder(FeedType.forYou)),
            AutomaticKeepAliveFeedBuilder(widget.feedBuilder(FeedType.yourFeed)),
          ],
        ),
      ),
    ],);
  }

  @override
  void dispose() {
    tabController.removeListener(_updateValueNotifier);
    tabController.dispose();
    super.dispose();
  }
}

class AutomaticKeepAliveFeedBuilder extends StatefulWidget {
  const AutomaticKeepAliveFeedBuilder(this.child, {super.key});

  final Widget child;
  @override
  State<AutomaticKeepAliveFeedBuilder> createState() => _AutomaticKeepAliveFeedBuilderState();
}

class _AutomaticKeepAliveFeedBuilderState extends State<AutomaticKeepAliveFeedBuilder> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}


class _CallbackProvider extends InheritedWidget {
  final GetAppUserCallback getAppUser;
  final OnAuthenticationRequestedCallback onAuthenticationRequest;

  const _CallbackProvider({
    required this.getAppUser,
    required this.onAuthenticationRequest,
    required super.child,
  });

  static _CallbackProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_CallbackProvider>();
  }

  static _CallbackProvider of(BuildContext context) {
    final _CallbackProvider? result = maybeOf(context);
    assert(result != null, 'No _CallbackProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(_CallbackProvider oldWidget) {
    return false;
  }
}