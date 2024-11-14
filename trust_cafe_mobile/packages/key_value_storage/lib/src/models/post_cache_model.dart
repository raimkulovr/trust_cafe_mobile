import 'package:hive/hive.dart';
import 'package:key_value_storage/src/models/reactions_cache_model.dart';

import 'author_cache_model.dart';

part 'post_cache_model.g.dart';

@HiveType(typeId: 1)
class PostCacheModel{
  const PostCacheModel({
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

  @HiveField(0)
  final bool collaborative;
  @HiveField(1)
  final PostStatisticsCacheModel statistics;
  @HiveField(2)
  final int createdAt;
  @HiveField(3)
  final String postId;
  @HiveField(4)
  final String postText;
  @HiveField(5)
  final PostDataCacheModel data;
  @HiveField(6)
  final int updatedAt;
  @HiveField(7)
  final int subReply;
  @HiveField(8)
  final String sk;
  @HiveField(9)
  final String pk;
  @HiveField(10)
  final String? cardUrl;
  @HiveField(11)
  final List<AuthorCacheModel>? authors;
  @HiveField(12)
  final String? blurLabel;
  @HiveField(13)
  final String? archivedBy;

}

@HiveType(typeId: 4)
class PostStatisticsCacheModel {
  const PostStatisticsCacheModel({
    required this.authorCount,
    required this.commentCount,
    required this.topLevelCommentCount,
    required this.revisionCount,
    required this.voteCount,
    required this.voteValueSum,
    this.reactions,
  });

  @HiveField(0)
  final int authorCount;
  @HiveField(1)
  final int commentCount;
  @HiveField(2)
  final int topLevelCommentCount;
  @HiveField(3)
  final int revisionCount;
  @HiveField(4)
  final int voteCount;
  @HiveField(5)
  final int voteValueSum;
  @HiveField(6)
  final ReactionsCacheModel? reactions;

}

@HiveType(typeId: 5)
class PostDataCacheModel {
  const PostDataCacheModel({
    required this.createdByUser,
    required this.subwiki,
    required this.maintrunk,
    required this.userprofile,
  });

  @HiveField(0)
  final AuthorCacheModel createdByUser;
  @HiveField(1)
  final SubwikiPostOriginCacheModel? subwiki;
  @HiveField(2)
  final MainTrunkPostOriginCacheModel? maintrunk;
  @HiveField(3)
  final UserProfilePostOriginCacheModel? userprofile;

}

@HiveType(typeId: 6)
class SubwikiPostOriginCacheModel {
  SubwikiPostOriginCacheModel({
    this.slug,
    this.sk,
    this.pk,
    this.label,
  });

  @HiveField(0)
  final String? slug;
  @HiveField(1)
  final String? sk;
  @HiveField(2)
  final String? pk;
  @HiveField(3)
  final String? label;

}

@HiveType(typeId: 7)
class MainTrunkPostOriginCacheModel {
  const MainTrunkPostOriginCacheModel({
    this.slug,
    this.sk,
    this.pk,
  });

  @HiveField(0)
  final String? slug;
  @HiveField(1)
  final String? sk;
  @HiveField(2)
  final String? pk;

}

@HiveType(typeId: 8)
class UserProfilePostOriginCacheModel {
  UserProfilePostOriginCacheModel({
    this.slug,
    this.sk,
    this.pk,
    this.fname,
    this.lname,
    this.userId,
  });

  @HiveField(0)
  final String? slug;
  @HiveField(1)
  final String? sk;
  @HiveField(2)
  final String? pk;
  @HiveField(3)
  final String? fname;
  @HiveField(4)
  final String? lname;
  @HiveField(5)
  final String? userId;

}


