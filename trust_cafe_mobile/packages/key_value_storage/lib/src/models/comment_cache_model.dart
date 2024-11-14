import 'package:hive/hive.dart';
import 'package:key_value_storage/src/models/reactions_cache_model.dart';
import 'author_cache_model.dart';

part 'comment_cache_model.g.dart';

@HiveType(typeId: 10)
class CommentCacheModel{
  const CommentCacheModel({
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
    required this.archived,
    required this.deleted,
    required this.topLevel,
    required this.blurLabel,
  });

  @HiveField(0)
  final String path;
  @HiveField(1)
  final CommentStatisticsCacheModel statistics;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final int createdAt;
  @HiveField(4)
  final int updatedAt;
  @HiveField(5)
  final CommentDestinationCacheModel topLevelDestination;
  @HiveField(6)
  final int level;
  @HiveField(7)
  final String commentText;
  @HiveField(8)
  final int subReply;
  @HiveField(9)
  final String sk;
  @HiveField(10)
  final String pk;
  @HiveField(11)
  final List<AuthorCacheModel> authors;
  @HiveField(12)
  final CommentDataCacheModel data;
  @HiveField(13)
  final bool? archived;
  @HiveField(14)
  final bool? deleted;
  @HiveField(15)
  final CommentOriginCacheModel topLevel;
  @HiveField(16)
  final String? blurLabel;

}

@HiveType(typeId: 11)
class CommentStatisticsCacheModel {
  const CommentStatisticsCacheModel({
    required this.authorCount,
    required this.commentReplies,
    required this.revisionCount,
    this.voteCount = 0,
    this.voteValueSum = 0,
    this.reactions,
  });

  @HiveField(0)
  final int authorCount;
  @HiveField(1)
  final int commentReplies;
  @HiveField(2)
  final int revisionCount;
  @HiveField(3)
  final int voteCount;
  @HiveField(4)
  final int voteValueSum;
  @HiveField(5)
  final ReactionsCacheModel? reactions;

}

@HiveType(typeId: 12)
class CommentDestinationCacheModel {
  CommentDestinationCacheModel({
    required this.name,
    required this.entity,
    required this.slug,
  });

  @HiveField(0)
  final String name;
  @HiveField(1)
  final String entity;
  @HiveField(2)
  final String slug;
}

@HiveType(typeId: 13)
class CommentDataCacheModel {
  const CommentDataCacheModel({
    required this.createdByUser,
    this.post,
    this.comment,
  });

  @HiveField(0)
  final AuthorCacheModel createdByUser;
  @HiveField(1)
  final CommentOriginCacheModel? post;
  @HiveField(2)
  final CommentOriginCacheModel? comment;

}

@HiveType(typeId: 14)
class CommentOriginCacheModel {
  const CommentOriginCacheModel({
    required this.sk,
    required this.pk,
    required this.slug,
    required this.createdByUser,
  });

  @HiveField(0)
  final String sk;
  @HiveField(1)
  final String pk;
  @HiveField(2)
  final String slug;
  @HiveField(3)
  final AuthorCacheModel? createdByUser;

}