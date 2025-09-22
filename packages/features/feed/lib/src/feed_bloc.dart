import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc({
    required ContentRepository contentRepository,
    required ScrollController scrollController,
    required this.onRefreshStreamController,
    required this.appUser,
    required this.feedType,
    this.feedSlugData,
  }) :  assert(
          (feedType==FeedType.profile || feedType==FeedType.branch) && feedSlugData!=null ||
          (feedType==FeedType.forYou || feedType==FeedType.yourFeed || feedType==FeedType.allProfiles || feedType==FeedType.removed) && feedSlugData == null, 'Slug must be provided for profile and branch feeds'),
        _contentRepository = contentRepository,
        _scrollController = scrollController,
        super(const FeedState())
  {
    _registerEventsHandler();
    add(const FeedStarted());
  }

  final AppUser appUser;
  final ContentRepository _contentRepository;
  final ScrollController _scrollController;
  final StreamController onRefreshStreamController;
  final FeedType feedType;
  final String? feedSlugData;

  void _registerEventsHandler() {
    on<FeedNextPageRequested>(_onFeedNextPageRequested);
    on<FeedFailedFetchRetried>(_onFeedFailedFetchRetried);
    on<FeedPostUpdated>(_onFeedPostUpdated);
    on<FeedRefreshed>(_onFeedRefreshed);
    on<FeedPostRemoved>(_onFeedPostRemoved);
    on<FeedStarted>(_onFeedStarted);
    on<FeedPostAdded>(_onFeedPostAdded);
  }

  Future<void> _onFeedStarted(
      FeedStarted event,
      Emitter<FeedState> emit,
  ) async {
    final firstPageFetchStream = _fetchPage(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    return emit.onEach<FeedState>(
      firstPageFetchStream,
      onData: emit.call,
    );
  }

  Stream<FeedState> _fetchPage(
  {
    required FetchPolicy fetchPolicy,
    String? pageKey,
    bool isRefresh = false,
  }) async* {

    final pagesStream = _contentRepository.getFeedPage(
        pageKey: pageKey,
        feedType: feedType,
        slug: feedSlugData,
        fetchPolicy: fetchPolicy);

    try {
      await for (final newPage in pagesStream) {

        final newItemList = newPage.postList;
        final oldItemList = state.postList ?? [];
        final completeItemList = isRefresh || pageKey == null
            ? newItemList
            : (oldItemList + newItemList);

        final nextPageKey = newPage.nextPageKey;
        yield FeedState.success(
          nextPageKey: nextPageKey,
          postList: completeItemList,
        );
      }

    } catch (error) {
      if (isRefresh) {
        yield state.copyWithNewRefreshError(
          error,
        );
      } else {
        yield state.copyWithNewError(
          error,
        );
      }
    }
  }

  Future<void> _onFeedRefreshed(
      FeedRefreshed event,
      Emitter<FeedState> emit,
  ) async {
    final firstPageFetchStream = _fetchPage(
      fetchPolicy: FetchPolicy.networkOnly,
      isRefresh: true,
    );

    await emit.onEach<FeedState>(
      firstPageFetchStream,
      onData: emit.call,
    );
    onRefreshStreamController.add(null);
  }

  Future<void> _onFeedNextPageRequested(
      FeedNextPageRequested event,
      Emitter<FeedState> emit,
  ) async {
    emit(
      state.copyWithNewError(null),
    );

    final nextPageFetchStream = _fetchPage(
      pageKey: event.pageKey,
      fetchPolicy: FetchPolicy.networkPreferably,
    );

    return emit.onEach<FeedState>(
      nextPageFetchStream,
      onData: emit.call,
    );
  }

  Future<void> _onFeedFailedFetchRetried(
      FeedFailedFetchRetried event,
      Emitter emit,
  ) async {
    emit(
      state.copyWithNewError(null),
    );

    final firstPageFetchStream = _fetchPage(
      fetchPolicy: FetchPolicy.cacheAndNetwork,
    );

    return emit.onEach<FeedState>(
      firstPageFetchStream,
      onData: emit.call,
    );
  }

  Future<void> _onFeedPostUpdated(
      FeedPostUpdated event,
      Emitter<FeedState> emit,
  ) async {
    emit(
      state.copyWithUpdatedPost(
        event.updatedPost,
      ),
    );
  }

  Future<void> _onFeedPostAdded(
      FeedPostAdded event,
      Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(postList: [event.post, ...?state.postList]));
    _contentRepository.addPostToFeed(event.post.postId, feedType: feedType, feedSlugData: feedSlugData);
  }

  Future<void> _onFeedPostRemoved(
      FeedPostRemoved event,
      Emitter<FeedState> emit,
  ) async {
    emit(state.copyWith(postList: state.postList?.where((e) => e.postId!=event.postId,).toList(),));
    _contentRepository.removePostFromFeed(event.postId, feedType: feedType, feedSlugData: feedSlugData);
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
