part of 'comment_cubit.dart';

enum CommentStateErrors{
  edit,
  reactionCast,
  translation,
  voteCast,
  archive,
  restore,
}

class CommentState extends Equatable {
  const CommentState({
    required this.commentText,
    required this.voteValueSum,
    required this.voteCount,
    required this.reactions,
    required this.isBlurHidden,
    required this.isArchivedHidden,
    required this.blurLabel,
    required this.archived,
    this.translationIsProcessing = false,
    this.translation,
    this.isUpvoted,
    this.reaction = 'none',
    this.error,
  });

  final String commentText;
  final int voteValueSum;
  final int voteCount;
  final Reactions reactions;
  final bool translationIsProcessing;
  final String reaction;
  final bool isBlurHidden;
  final bool isArchivedHidden;
  final bool archived;
  final String? translation;
  final bool? isUpvoted;
  final String? blurLabel;
  final CommentStateErrors? error;

  @override
  List<Object?> get props => [
    commentText,
    voteValueSum,
    voteCount,
    translation,
    translationIsProcessing,
    isUpvoted,
    reaction,
    reactions,
    isBlurHidden,
    isArchivedHidden,
    blurLabel,
    archived,
    error,
  ];

  CommentState copyWith({
    String? commentText,
    int? voteValueSum,
    int? voteCount,
    Reactions? reactions,
    bool? translationIsProcessing,
    String? reaction,
    bool? isBlurHidden,
    bool? isArchivedHidden,
    bool? archived,
    Wrapped<String?>? translation,
    Wrapped<bool?>? isUpvoted,
    Wrapped<String?>? blurLabel,
    Wrapped<CommentStateErrors?>? error,
  }) {
    return CommentState(
      commentText: commentText ?? this.commentText,
      voteValueSum: voteValueSum ?? this.voteValueSum,
      voteCount: voteCount ?? this.voteCount,
      reactions: reactions ?? this.reactions,
      reaction: reaction ?? this.reaction,
      isBlurHidden: isBlurHidden ?? this.isBlurHidden,
      isArchivedHidden: isArchivedHidden ?? this.isArchivedHidden,
      archived: archived ?? this.archived,
      translationIsProcessing: translationIsProcessing ?? this.translationIsProcessing,
      translation: translation!=null ? translation.value : this.translation,
      isUpvoted: isUpvoted!=null ? isUpvoted.value : this.isUpvoted,
      blurLabel: blurLabel!=null ? blurLabel.value : this.blurLabel,
      error: error!=null ? error.value : this.error,
    );
  }

  Comment getCommentRepresentation(Comment comment) => comment.copyWith(
      archived: archived,
      commentText: commentText,
      blurLabel: Wrapped.value(blurLabel),
      statistics: comment.statistics.copyWith(
        voteCount: voteCount,
        voteValueSum: voteValueSum,
        reactions: reactions,
      ));

  @override
  String toString() {
    return 'CommentState{commentText: ${commentText.safeSubstring(end: 50)}, voteValueSum: $voteValueSum, voteCount: $voteCount, reactions: $reactions, translationIsProcessing: $translationIsProcessing, reaction: $reaction, isBlurHidden: $isBlurHidden, isArchivedHidden: $isArchivedHidden, archived: $archived, translation: $translation, isUpvoted: $isUpvoted, blurLabel: $blurLabel, error: $error,}';
  }
}


extension CommentCompare on Comment {
  bool isEqualTo(Comment comment) =>
      archived == comment.archived &&
      data == comment.data &&
      commentText == comment.commentText &&
      blurLabel == comment.blurLabel &&
      statistics.voteCount == comment.statistics.voteCount &&
      statistics.voteValueSum == comment.statistics.voteValueSum &&
      statistics.reactions == comment.statistics.reactions;

  bool isNotEqualTo(Comment comment) => !isEqualTo(comment);
}