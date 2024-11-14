import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'author.dart';
import 'reactions.dart';

class Comment extends Equatable{
  const Comment({
    required this.path,
    required this.statistics,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.topLevelDestination,
    required this.level,
    required this.commentText,
    required this.subReply,
    required this.sk,
    required this.pk,
    required this.authors,
    required this.data,
    required this.topLevel,
    required this.archived,
    required this.deleted,
    required this.blurLabel,
  });

  final String path;
  final CommentStatistics statistics;
  final String slug;
  final int createdAt;
  final int updatedAt;
  final CommentDestination topLevelDestination;
  final int level;
  final String commentText;
  final int subReply;
  final String sk;
  final String pk;
  final List<Author> authors;
  final CommentData data;
  final bool archived;
  final bool deleted;
  final CommentOrigin topLevel;
  final String? blurLabel;

  @override
  List<Object?> get props => [
    path,
    statistics,
    slug,
    createdAt,
    updatedAt,
    topLevelDestination,
    level,
    commentText,
    subReply,
    sk,
    pk,
    authors,
    data,
    archived,
    deleted,
    topLevel,
    blurLabel,
  ];

  Comment copyWith({
    String? path,
    CommentStatistics? statistics,
    String? slug,
    int? createdAt,
    int? updatedAt,
    CommentDestination? topLevelDestination,
    int? level,
    String? commentText,
    int? subReply,
    String? sk,
    String? pk,
    List<Author>? authors,
    CommentData? data,
    bool? archived,
    bool? deleted,
    CommentOrigin? topLevel,
    Wrapped<String?>? blurLabel,
  }) {
    return Comment(
      path: path ?? this.path,
      statistics: statistics ?? this.statistics,
      slug: slug ?? this.slug,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      topLevelDestination: topLevelDestination ?? this.topLevelDestination,
      level: level ?? this.level,
      commentText: commentText ?? this.commentText,
      subReply: subReply ?? this.subReply,
      sk: sk ?? this.sk,
      pk: pk ?? this.pk,
      authors: authors ?? this.authors,
      data: data ?? this.data,
      archived: archived ?? this.archived,
      deleted: deleted ?? this.deleted,
      topLevel: topLevel ?? this.topLevel,
      blurLabel: blurLabel!=null ? blurLabel.value : this.blurLabel,
    );
  }

}

class CommentStatistics extends Equatable{
  const CommentStatistics({
    required this.authorCount,
    required this.commentReplies,
    required this.revisionCount,
    required this.reactions,
    this.voteCount = 0,
    this.voteValueSum = 0,
  });

  final int authorCount;
  final int commentReplies;
  final int revisionCount;
  final int voteCount;
  final int voteValueSum;
  final Reactions reactions;

  @override
  List<Object?> get props => [
    authorCount,
    commentReplies,
    revisionCount,
    voteCount,
    voteValueSum,
    reactions,
  ];

  CommentStatistics copyWith({
    int? authorCount,
    int? commentReplies,
    int? revisionCount,
    int? voteCount,
    int? voteValueSum,
    Reactions? reactions,
  }) {
    return CommentStatistics(
      authorCount: authorCount ?? this.authorCount,
      commentReplies: commentReplies ?? this.commentReplies,
      revisionCount: revisionCount ?? this.revisionCount,
      voteCount: voteCount ?? this.voteCount,
      voteValueSum: voteValueSum ?? this.voteValueSum,
      reactions: reactions ?? this.reactions,
    );
  }
}

class CommentDestination extends Equatable {
  CommentDestination({
    required this.name,
    required this.entity,
    required this.slug,
  });

  final String name;
  final String entity;
  final String slug;

  @override
  List<Object?> get props => [
    name,
    entity,
    slug,
  ];
}

class CommentData extends Equatable {
  const CommentData({
    required this.createdByUser,
    this.post,
    this.comment,
  });

  final Author createdByUser;
  final CommentOrigin? post;
  final CommentOrigin? comment;

  @override
  List<Object?> get props => [
    createdByUser,
    post,
    comment,
  ];
}

class CommentOrigin extends Equatable{
  const CommentOrigin({
    required this.sk,
    required this.pk,
    required this.slug,
    required this.createdByUser,
  });

  final String sk;
  final String pk;
  final String slug;
  final Author? createdByUser;


  @override
  List<Object?> get props => [
    sk,
    pk,
    slug,
    createdByUser,
  ];
}
