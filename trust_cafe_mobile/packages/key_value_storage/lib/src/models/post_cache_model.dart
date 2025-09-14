import 'package:hive_ce/hive.dart';

import 'package:key_value_storage/src/models/reactions_cache_model.dart';

import 'author_cache_model.dart';

class PostCacheModel extends HiveObject {
  PostCacheModel({
    required this.collaborative,
    required this.statistics,
    required this.createdAt,
    required this.postId,
    required this.postText,
    required this.data,
    required this.updatedAt,
    required this.subReply,
    required this.sk,
    required this.cardUrl,
    required this.pk,
    required this.authors,
    required this.blurLabel,
    required this.archivedBy,
  });

  final bool collaborative;
  final PostStatisticsCacheModel statistics;
  final int createdAt;
  final String postId;
  final String postText;
  final PostDataCacheModel data;
  final int updatedAt;
  final int subReply;
  final String sk;
  final String pk;
  final String? cardUrl;
  final List<AuthorCacheModel>? authors;
  final String? blurLabel;
  final String? archivedBy;

}

class PostStatisticsCacheModel extends HiveObject {
  PostStatisticsCacheModel({
    required this.authorCount,
    required this.commentCount,
    required this.topLevelCommentCount,
    required this.revisionCount,
    required this.voteCount,
    required this.voteValueSum,
    this.reactions,
  });

  final int authorCount;
  final int commentCount;
  final int topLevelCommentCount;
  final int revisionCount;
  final int voteCount;
  final int voteValueSum;
  final ReactionsCacheModel? reactions;

}

class PostDataCacheModel extends HiveObject {
  PostDataCacheModel({
    required this.createdByUser,
    required this.subwiki,
    required this.maintrunk,
    required this.userprofile,
  });

  final AuthorCacheModel createdByUser;
  final SubwikiPostOriginCacheModel? subwiki;
  final MainTrunkPostOriginCacheModel? maintrunk;
  final UserProfilePostOriginCacheModel? userprofile;

}

class SubwikiPostOriginCacheModel extends HiveObject {
  SubwikiPostOriginCacheModel({
    this.slug,
    this.sk,
    this.pk,
    this.label,
  });

  final String? slug;
  final String? sk;
  final String? pk;
  final String? label;

}

class MainTrunkPostOriginCacheModel extends HiveObject {
  MainTrunkPostOriginCacheModel({
    this.slug,
    this.sk,
    this.pk,
  });

  final String? slug;
  final String? sk;
  final String? pk;

}

class UserProfilePostOriginCacheModel extends HiveObject {
  UserProfilePostOriginCacheModel({
    this.slug,
    this.sk,
    this.pk,
    this.fname,
    this.lname,
    this.userId,
  });

  final String? slug;
  final String? sk;
  final String? pk;
  final String? fname;
  final String? lname;
  final String? userId;

}
