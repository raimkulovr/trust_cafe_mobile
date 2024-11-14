part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable{
  const CommentsEvent();

  @override
  List<Object?> get props => [];
}

class CommentsPostDataObtained extends CommentsEvent {
  const CommentsPostDataObtained(this.postData);
  final PostData? postData;

  @override
  List<Object?> get props => [postData];
}

class CommentsFailedFetchRetried extends CommentsEvent {
  const CommentsFailedFetchRetried();
}

class CommentsUsernameObtained extends CommentsEvent {
  const CommentsUsernameObtained({this.authenticatedUser});

  final AppUser? authenticatedUser;

  @override
  List<Object?> get props => [authenticatedUser];
}

class CommentsRefreshed extends CommentsEvent {
  const CommentsRefreshed();
}

class CommentsNextPageRequested extends CommentsEvent {
  const CommentsNextPageRequested({
    required this.pageKey,
  });

  final String pageKey;

  @override
  List<Object?> get props => [
    pageKey
  ];
}

class CommentsCommentUpdated extends CommentsEvent {
  const CommentsCommentUpdated(this.updatedComment,);

  final Comment updatedComment;

  @override
  List<Object?> get props => [updatedComment];
}

class CommentsCommentCreated extends CommentsEvent {
  const CommentsCommentCreated({
    required this.postId,
    required this.parentSk,
    required this.parentPk,
    required this.parentSlug,
    required this.commentText,
    required this.simple,
    required this.blurLabel,
  });

  final String postId;
  final String parentSk;
  final String parentPk;
  final String parentSlug;
  final String commentText;
  final bool simple;
  final String? blurLabel;

  @override
  List<Object?> get props => [
    postId,
    parentSk,
    parentPk,
    parentSlug,
    commentText,
    simple,
    blurLabel,
  ];
}