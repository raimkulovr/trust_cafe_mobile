part of 'comments_bloc.dart';

enum CommentsStateErrors{
  refresh,
  newComment,
}

class CommentsState extends Equatable {
  const CommentsState({
    this.commentList,
    this.nextPageKey,
    this.authenticatedUser,
    this.creatingNewComment = false,
    this.error,
    this.pagingError,
  });

  final List<Comment>? commentList;

  final String? nextPageKey;
  final bool creatingNewComment;
  final AppUser? authenticatedUser;
  final CommentsStateErrors? error;
  final dynamic pagingError;

  bool get canComment => (authenticatedUser?.isNotGuest) ?? false;

  const CommentsState.success({
    required String? nextPageKey,
    required List<Comment> commentList,
    required AppUser? authenticatedUser,
  }) : this(
    nextPageKey: nextPageKey,
    commentList: commentList,
    authenticatedUser: authenticatedUser,
  );

  CommentsState copyWithNewPagingError(dynamic error) =>
      copyWith(pagingError: Wrapped.value(error));

  CommentsState copyWithNewRefreshError(dynamic refreshError) =>
      copyWith(error: Wrapped.value(refreshError!=null ? CommentsStateErrors.refresh : null));

  CommentsState copyWithNewCommentError(dynamic createNewCommentError) =>
      copyWith(error: Wrapped.value(createNewCommentError !=null ? CommentsStateErrors.newComment : null), creatingNewComment: false);

  CommentsState copyWithUpdatedComment(Comment updatedComment) =>
      copyWith(
        commentList: Wrapped.value(commentList?.map((comment) {
          if (comment.slug == updatedComment.slug) {
            return updatedComment;
          } else {
            return comment;
          }
        }).toList()),
      );

  @override
  List<Object?> get props => [
    commentList,
    nextPageKey,
    authenticatedUser,
    creatingNewComment,
    error,
    pagingError,
  ];

  @override
  String toString() {
    return 'CommentsState{commentList: ${commentList?.length}, nextPageKey: $nextPageKey, creatingNewComment: $creatingNewComment, authenticatedUser: $authenticatedUser, error: $error, pagingError: $pagingError}';
  }

  CommentsState copyWith({
    Wrapped<List<Comment>?>? commentList,
    Wrapped<String?>? nextPageKey,
    Wrapped<AppUser?>? authenticatedUser,
    bool? creatingNewComment,
    Wrapped<CommentsStateErrors?>? error,
    Wrapped<dynamic>? pagingError,
  }) {
    return CommentsState(
      commentList: commentList !=null ? commentList.value : this.commentList,
      nextPageKey: nextPageKey !=null ? nextPageKey.value : this.nextPageKey,
      authenticatedUser: authenticatedUser !=null ? authenticatedUser.value : this.authenticatedUser,
      creatingNewComment: creatingNewComment ?? this.creatingNewComment,
      error: error!=null ? error.value : this.error,
      pagingError: pagingError!=null ? pagingError.value : this.pagingError,
    );
  }
}

class CommentsPostData extends Equatable {
  const CommentsPostData({
    required this.postId,
    required this.sk,
    required this.pk,
    required this.slug,
  });

  final String postId;
  final String sk;
  final String pk;
  final String slug;

  CommentsPostData.fromPost(Post post) : postId = post.postId, sk = post.sk, pk = post.pk, slug = post.postId;

  @override
  List<Object?> get props => [
    postId,
    sk,
    pk,
    slug,
  ];
}