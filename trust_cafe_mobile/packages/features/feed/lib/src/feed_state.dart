part of 'feed_bloc.dart';

class FeedState extends Equatable {
  const FeedState({
    this.postList,
    this.nextPageKey,
    this.error,
    this.refreshError,
});

  final List<Post>? postList;

  final String? nextPageKey;

  final dynamic error;

  final dynamic refreshError;

  const FeedState.success({
    required String? nextPageKey,
    required List<Post> postList,
  }) : this(
    nextPageKey: nextPageKey,
    postList: postList,
  );

  FeedState copyWithNewError(dynamic error) =>
      FeedState(
        postList: postList,
        nextPageKey: nextPageKey,
        error: error,
        refreshError: null,
      );

  FeedState copyWithNewRefreshError(dynamic refreshError) =>
      FeedState(
        postList: postList,
        nextPageKey: nextPageKey,
        error: null,
        refreshError: refreshError,
      );

  FeedState copyWithUpdatedPost(Post updatedPost) =>
      copyWith(postList: postList?.map((post) {
        if (post.postId == updatedPost.postId) {
          return updatedPost;
        } else {
          return post;
        }
      }).toList());

  @override
  List<Object?> get props => [
    postList,
    nextPageKey,
    error,
    refreshError,
  ];

  FeedState copyWith({
    List<Post>? postList,
    String? nextPageKey,
    Wrapped<dynamic>? error,
    Wrapped<dynamic>? refreshError,
  }) {
    return FeedState(
      postList: postList ?? this.postList,
      nextPageKey: nextPageKey ?? this.nextPageKey,
      error: error!=null ? error.value : this.error,
      refreshError: refreshError!=null ? refreshError.value : this.refreshError,
    );
  }

  @override
  String toString() {
    return 'FeedState{postList: ${postList?.length}, nextPageKey: $nextPageKey, error: $error, refreshError: $refreshError}';
  }
}