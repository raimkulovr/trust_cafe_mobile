import 'package:hive_ce/hive.dart';

import 'package:key_value_storage/src/models/reactions_cache_model.dart';
import 'author_cache_model.dart';


class CommentCacheModel extends HiveObject {
  CommentCacheModel({
    required this.statistics,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
    required this.level,
    required this.commentText,
    required this.sk,
    required this.pk,
    required this.authors,
    required this.data,
    required this.archived,
    required this.deleted,
    required this.topLevel,
    required this.blurLabel,
  });

  final CommentStatisticsCacheModel statistics;
  final String slug;
  final int createdAt;
  final int updatedAt;
  final int level;
  final String commentText;
  final String sk;
  final String pk;
  final List<AuthorCacheModel> authors;
  final CommentDataCacheModel data;
  final bool? archived;
  final bool? deleted;
  final CommentOriginCacheModel topLevel;
  final String? blurLabel;

}

class CommentStatisticsCacheModel extends HiveObject {
  CommentStatisticsCacheModel({
    required this.authorCount,
    required this.commentReplies,
    required this.revisionCount,
    this.voteCount = 0,
    this.voteValueSum = 0,
    this.reactions,
  });

  final int authorCount;
  final int commentReplies;
  final int revisionCount;
  final int voteCount;
  final int voteValueSum;
  final ReactionsCacheModel? reactions;

}

class CommentDestinationCacheModel extends HiveObject {
  CommentDestinationCacheModel({
    required this.name,
    required this.entity,
    required this.slug,
  });

  final String name;
  final String entity;
  final String slug;
}

class CommentDataCacheModel extends HiveObject {
  CommentDataCacheModel({
    required this.createdByUser,
    this.post,
    this.comment,
  });

  final AuthorCacheModel createdByUser;
  final CommentOriginCacheModel? post;
  final CommentOriginCacheModel? comment;
}

class CommentOriginCacheModel extends HiveObject {
  CommentOriginCacheModel({
    required this.sk,
    required this.pk,
    required this.slug,
    required this.createdByUser,
  });

  final String sk;
  final String pk;
  final String slug;
  final AuthorCacheModel? createdByUser;
}