part of 'feed_bloc.dart';

class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class FeedStarted extends FeedEvent {
  const FeedStarted();
}

class FeedUsernameObtained extends FeedEvent {
  const FeedUsernameObtained({this.authenticatedUser});

  final AppUser? authenticatedUser;
}

class FeedRefreshed extends FeedEvent {
  const FeedRefreshed();
}

class FeedNextPageRequested extends FeedEvent {
  const FeedNextPageRequested({
    required this.pageKey,
  });

  final String pageKey;

  @override
  List<Object?> get props => [pageKey];
}

class FeedPostVoteCasted extends FeedEvent {
  const FeedPostVoteCasted(this.postId, {
    required this.sk,
    required this.pk,
    this.isUpvote,
  });

  final String postId;
  final String sk;
  final String pk;
  final bool? isUpvote;

  @override
  List<Object?> get props => [
    postId,
    isUpvote,
    sk,
    pk,
  ];
}

class FeedFailedFetchRetried extends FeedEvent {
  const FeedFailedFetchRetried();
}

class FeedPostUpdated extends FeedEvent {
  const FeedPostUpdated(this.updatedPost,);

  final Post updatedPost;

  @override
  List<Object?> get props => [updatedPost];
}

class FeedPostRemoved extends FeedEvent {
  const FeedPostRemoved({
    required this.postId,
  });

  final String postId;

  @override
  List<Object?> get props => [
    postId,
  ];
}

class FeedPostAdded extends FeedEvent {
  const FeedPostAdded(this.post);

  final Post post;

  @override
  List<Object> get props =>
      [post];

}
