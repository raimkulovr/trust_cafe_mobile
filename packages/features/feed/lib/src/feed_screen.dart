import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post/post.dart';
import 'package:user_repository/user_repository.dart';

import 'feed_bloc.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    required this.contentRepository,
    required this.userRepository,
    required this.appUser,
    required this.feedType,
    required this.feedSlugData,
    this.scrollPositionResetManager,
    this.newPostStream,
    super.key,
  });

  final ContentRepository contentRepository;
  final UserRepository userRepository;
  final AppUser appUser;
  final FeedType feedType;
  final String? feedSlugData;
  final Stream<FeedType>? scrollPositionResetManager;
  final Stream<Post>? newPostStream;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  late final ScrollController scrollController;
  late final StreamController onRefreshStreamController;

  @override
  void initState() {
    scrollController = ScrollController();
    onRefreshStreamController = StreamController.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    onRefreshStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CallbackProvider(
      getAppUser: ()=>widget.appUser,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: widget.contentRepository),
          RepositoryProvider.value(value: widget.userRepository),
        ],
        child: BlocProvider<FeedBloc>(
          create: (_) => FeedBloc(
              contentRepository: widget.contentRepository,
              scrollController: scrollController,
              onRefreshStreamController: onRefreshStreamController,
              appUser: widget.appUser,
              feedType: widget.feedType,
              feedSlugData: widget.feedSlugData,
          ),
          child: FeedView(
              scrollController: scrollController,
              scrollPositionResetManager: widget.scrollPositionResetManager,
              newPostStream: widget.newPostStream,
          ),
        ),
      ),
    );
  }
}

class FeedView extends StatefulWidget {
  const FeedView({
    required this.scrollController,
    this.scrollPositionResetManager,
    this.newPostStream,
    super.key,
  });

  final ScrollController scrollController;
  final Stream<FeedType>? scrollPositionResetManager;
  final Stream<Post>? newPostStream;

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final PagingController<String?, Post> _pagingController = PagingController(firstPageKey: null);
  late final ScrollController _scrollController;

  FeedBloc get _bloc => context.read<FeedBloc>();
  final Set<String> _utilUsedKeys = <String>{};

  late final StreamSubscription? scrollPositionResetSubscription;
  late final StreamSubscription? newPostStreamSubscription;

  @override
  void initState() {
    _scrollController = widget.scrollController;
    _pagingController.addPageRequestListener((pageKey) {
      final isSubsequentPage = pageKey!=null;
      if (isSubsequentPage && !_utilUsedKeys.contains(pageKey)) {
        _bloc.add(
          FeedNextPageRequested(
            pageKey: pageKey,
          ),
        );
        _utilUsedKeys.add(pageKey);
      }
    });

    cacheScrollDirection = ScrollDirection.reverse;
    _scrollController.addListener( _scrollControllerListener);
    scrollPositionResetSubscription = widget.scrollPositionResetManager?.listen((FeedType feedType) {
      if(feedType==_bloc.feedType) _resetScrollPosition();
    },);
    newPostStreamSubscription = widget.newPostStream?.listen((Post newPost) {
      if(newPost.data.userprofile!=null && _bloc.feedType==FeedType.forYou) return;
      _bloc.add(FeedPostAdded(newPost));
    },);

    super.initState();
  }

  void _scrollControllerListener() {
    cacheScrollDirection = _scrollController.position.userScrollDirection;
  }

  void _resetScrollPosition() {
    final initialPaginationState = _pagingController.value;
    _pagingController.refresh();
    _scrollController.jumpTo(0);
    cacheScrollDirection = ScrollDirection.reverse;
    Future.delayed(const Duration(milliseconds: 100), () {
      _pagingController.value = initialPaginationState;
    },);
  }

  late ScrollDirection cacheScrollDirection;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.refreshError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                //TODO: replace with l10n
                'REFRESH ERROR'
              ),
            ),
          );
        }
        if(state.error!=null){
          _utilUsedKeys.remove(state.nextPageKey);
        }
        _pagingController.value = state.toPagingState();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: RefreshIndicator(
          onRefresh: () {
            cacheScrollDirection = ScrollDirection.reverse;
            setState(() {});
            _utilUsedKeys.clear();
            _bloc.add(const FeedRefreshed());
            return _bloc.onRefreshStreamController.stream.first;
          },
            child: Builder(
                builder: (context) {
                  final appUser = _CallbackProvider.of(context).getAppUser();
                  return Column(
                    children: [
                      PagingListView(
                        pagingController: _pagingController,
                        scrollController: _scrollController,
                        onFirstPageErrorRetry: () => context.read<FeedBloc>().add(const FeedFailedFetchRetried(),),
                        itemBuilder: (context, post, index) {
                          //TODO: not to return posts from blocked and ignored users and branches

                          if(RepositoryProvider.of<UserRepository>(context).isIgnoringAuthor(post.data.createdByUser.slug) ||
                              (post.data.subwiki!=null && post.data.subwiki!.slug!=null && RepositoryProvider.of<UserRepository>(context).isIgnoringBranch(post.data.subwiki!.slug!))) return const SizedBox();

                          return PostScreen(
                            post: post,
                            postId: null,
                            key: ValueKey(post.hashCode),
                            onPostUpdated: (updatedPost)
                              => context.read<FeedBloc>().add(FeedPostUpdated(updatedPost)),
                            onPostRemoved: () => context.read<FeedBloc>().add(FeedPostRemoved(postId: post.postId)),
                            appUser: appUser,
                            isScrollingUp: cacheScrollDirection==ScrollDirection.forward,
                            userRepository: RepositoryProvider.of<UserRepository>(context),
                            contentRepository: RepositoryProvider.of<ContentRepository>(context),
                          );
                        },
                      ),
                    ],
                  );
                }
            ),
          ),
        ),

    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.removeListener( _scrollControllerListener);
    _scrollController.dispose();
    scrollPositionResetSubscription?.cancel();
    newPostStreamSubscription?.cancel();
    super.dispose();
  }
}

extension on FeedState {
  PagingState<String?, Post> toPagingState() {
    return PagingState(
      itemList: postList,
      nextPageKey: nextPageKey,
      error: error,
    );
  }
}

class _CallbackProvider extends InheritedWidget {
  final GetAppUserCallback getAppUser;

  const _CallbackProvider({
    required this.getAppUser,
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