import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:content_repository/content_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:domain_models/domain_models.dart';
import 'package:user_repository/user_repository.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc({
    required ContentRepository contentRepository,
    required UserRepository userRepository,
    required this.onRefreshStreamController,
    required this.postData,
  }) :  _contentRepository = contentRepository,
        super(const CommentsState())
  {
    log('COMMENTS BLOC STARTED ${postData.slug}');
    _registerEventsHandler();

    _authChangesSubscription = userRepository.getAppUser().listen((user) {
      log('COMMENTS BLOC USER: $user');
      add(CommentsUsernameObtained(authenticatedUser: user));
    });

  }

  final CommentsPostData postData;
  final ContentRepository _contentRepository;
  late final StreamSubscription _authChangesSubscription;
  final StreamController onRefreshStreamController;

  void _registerEventsHandler() {
    on<CommentsUsernameObtained>(_onCommentsUsernameObtained);
    on<CommentsNextPageRequested>(_onCommentsNextPageRequested);
    on<CommentsRefreshed>(_onCommentsRefreshed);
    on<CommentsFailedFetchRetried>(_onCommentsFailedFetchRetried);
    on<CommentsCommentUpdated>(_onCommentsCommentUpdated);
    on<CommentsCommentCreated>(_onCommentCreated);
  }

  Future<void> _onCommentsFailedFetchRetried(
      CommentsFailedFetchRetried event,
      Emitter emit,
  ) async {
    emit(
      state.copyWithNewPagingError(null),
    );

    final firstPageFetchStream = _fetchCommentPage(
      fetchPolicy: FetchPolicy.networkOnly,
    );

    return emit.onEach<CommentsState>(
      firstPageFetchStream,
      onData: emit.call,
    );
  }



  Future<void> _onCommentsUsernameObtained(
      CommentsUsernameObtained event,
      Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(authenticatedUser: Wrapped.value(event.authenticatedUser)));
    if(event.authenticatedUser!=null){
      final firstPageFetchStream = _fetchCommentPage(
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      );

      return emit.onEach<CommentsState>(
        firstPageFetchStream,
        onData: emit.call,
      );
    }
  }

  Future<void> _onCommentsRefreshed(
      CommentsRefreshed event,
      Emitter<CommentsState> emit,
  ) async {
    final firstPageFetchStream = _fetchCommentPage(
      fetchPolicy: FetchPolicy.networkOnly,
      isRefresh: true,
    );

    await emit.onEach<CommentsState>(
      firstPageFetchStream,
      onData: emit.call,
    );
    onRefreshStreamController.add(null);
  }

  Future<void> _onCommentsNextPageRequested(
      CommentsNextPageRequested event,
      Emitter<CommentsState> emit,
      ) async {
    final nextPageFetchStream = _fetchCommentPage(
      fetchPolicy: FetchPolicy.networkPreferably,
      pageKey: event.pageKey,
    );

    return emit.onEach<CommentsState>(
      nextPageFetchStream,
      onData: emit.call,
    );
  }

  Future<void> _onCommentsCommentUpdated(
      CommentsCommentUpdated event,
      Emitter<CommentsState> emit,
      ) async {
    emit(
      state.copyWithUpdatedComment(
        event.updatedComment,
      ),
    );
  }

  Stream<CommentsState> _fetchCommentPage({
    required FetchPolicy fetchPolicy,
    String? pageKey,
    bool isRefresh = false,
  }) async* {
    final pagesStream = _contentRepository.getCommentPage(
        postData.postId,
        pageKey,
        fetchPolicy: fetchPolicy);

    try {
      await for (final newPage in pagesStream) {
        //Abandon operation if user dismissed comments
        if(isClosed) return;
        final newItemList = newPage.commentList;
        final oldItemList = state.commentList ?? [];
        final completeItemList = isRefresh || pageKey == null
            ? newItemList
            : (oldItemList + newItemList);

        final nextPageKey = newPage.nextPageKey;
        yield CommentsState.success(
          nextPageKey: nextPageKey,
          commentList: completeItemList,
          authenticatedUser: state.authenticatedUser,
        );
      }

    } catch (error) {
      log('ERROR: $error');
      if (isRefresh) {
        yield state.copyWithNewRefreshError(error);
        yield state.copyWithNewRefreshError(null);
      } else {
        yield state.copyWithNewPagingError(error,);
      }

      rethrow;
    }
  }

  Future<void> _onCommentCreated(
      CommentsCommentCreated event,
      Emitter<CommentsState> emit,
  ) async {
    if(event.commentText.isEmpty || event.commentText == '') return;
    try {
      emit(state.copyWith(creatingNewComment: true));
      final commentText = event.simple
          ? event.commentText
              .replaceAll(RegExp(r'<[^>]*>'), '')
              .split('\n')
              .map((e) => '<p>$e</p>',)
              .join('<br>')
          : event.commentText;
      final newComment = await _contentRepository.createComment(
          postId: event.postId,
          parentSk: event.parentSk,
          parentPk: event.parentPk,
          parentSlug: event.parentSlug,
          commentText: commentText,
          blurLabel: event.blurLabel,
      );

      emit(state.copyWith(commentList: Wrapped.value([...?state.commentList, newComment]), creatingNewComment: false));
    } catch (e) {
      emit(state.copyWithNewCommentError(e));
      emit(state.copyWithNewCommentError(null));
    }
  }

  @override
  Future<void> close() async {
    await _authChangesSubscription.cancel();
    log('COMMENTS BLOC CLOSED');
    return super.close();
  }
}
