part of 'post_cubit.dart';

enum PostStateErrors{
  edit,
  reactionCast,
  translation,
  voteCast,
  movement,
  archive,
  restore,
  load,
}

class PostState extends Equatable {
  const PostState({
    required this.post,
    this.isBlurHidden,
    this.translationIsProcessing = false,
    this.translation,
    this.isUpvoted,
    this.reaction = 'none',
    this.error,
  });

  final Post post;
  final String reaction;
  final bool translationIsProcessing;
  final String? translation;
  final bool? isUpvoted;
  final bool? isBlurHidden;
  final PostStateErrors? error;
  String get postText => post.postText;
  bool get collaborative => post.collaborative;
  String get cardUrl => post.cardUrl;
  int get voteValueSum => post.statistics.voteValueSum;
  int get voteCount => post.statistics.voteCount;
  Reactions get reactions => post.statistics.reactions;
  PostData get postData => post.data;
  String? get blurLabel => post.blurLabel;
  String get postPk => postData.originPkSk;
  String? get archivedBy => post.archivedBy;
  bool get archived => archivedBy!=null;

  @override
  List<Object?> get props =>
  [
    post,
    reaction,
    translationIsProcessing,
    translation,
    isUpvoted,
    isBlurHidden,
    error,
  ];


  @override
  String toString() {
    return 'PostState{post: ${post.hashCode}, reaction: $reaction, translationIsProcessing: $translationIsProcessing, translation: $translation, isUpvoted: $isUpvoted, isBlurHidden: $isBlurHidden, error: $error}';
  }

  PostState copyWith({
    String? postText,
    bool? collaborative,
    String? cardUrl,
    int? voteValueSum,
    int? voteCount,
    bool? translationIsProcessing,
    String? reaction,
    Reactions? reactions,
    PostData? postData,
    Wrapped<bool?>? isBlurHidden,
    Wrapped<String?>? translation,
    Wrapped<bool?>? isUpvoted,
    Wrapped<String?>? blurLabel,
    Wrapped<String?>? archivedBy,
    Wrapped<PostStateErrors?>? error,
  }) {
    return PostState(
      post: post.copyWith(
        postText: postText ?? this.postText,
        collaborative: collaborative ?? this.collaborative,
        cardUrl: cardUrl ?? this.cardUrl,
        statistics: post.statistics.copyWith(
          voteValueSum: voteValueSum ?? this.voteValueSum,
          voteCount: voteCount ?? this.voteCount,
          reactions: reactions ?? this.reactions,
        ),
        data: postData ?? this.postData,
        blurLabel: blurLabel,
        archivedBy: archivedBy,
      ),
      translationIsProcessing:
          translationIsProcessing ?? this.translationIsProcessing,
      reaction: reaction ?? this.reaction,
      isBlurHidden: isBlurHidden!=null ? isBlurHidden.value : this.isBlurHidden,
      translation: translation!=null ? translation.value : this.translation,
      isUpvoted: isUpvoted!=null ? isUpvoted.value : this.isUpvoted,
      error: error!=null ? error.value : this.error,
    );
  }

}


extension PostCompare on Post {
  bool isEqualTo(Post post) =>
      data == post.data &&
      postText == post.postText &&
      collaborative == post.collaborative &&
      cardUrl == post.cardUrl &&
      blurLabel == post.blurLabel &&
      statistics.voteCount == post.statistics.voteCount &&
      statistics.voteValueSum == post.statistics.voteValueSum &&
      statistics.reactions == post.statistics.reactions &&
      archivedBy == post.archivedBy;

  bool isNotEqualTo(Post post) => !isEqualTo(post);
}