import 'package:hive_ce/hive.dart';

import '../../key_value_storage.dart';

class SubwikiCacheModel extends HiveObject {
  SubwikiCacheModel({
    required this.slug,
    required this.subwikiLabel,
    required this.subwikiDesc,
    required this.createdAt,
    required this.statistics,
    required this.branchColor,
    required this.branchId,
    required this.isFollowing,
    this.subwikiLang,
    this.createdByUser,
    this.branchIcon,
  });

  final String slug;
  final String subwikiLabel;
  final String subwikiDesc;
  final int createdAt;
  final SubwikiStatisticsCacheModel statistics;
  final String? subwikiLang;
  final AuthorCacheModel? createdByUser;
  final String? branchIcon;
  final String? branchColor;
  final String? branchId;
  final bool? isFollowing;
}

class SubwikiStatisticsCacheModel extends HiveObject {
  SubwikiStatisticsCacheModel({
    required this.totalFollowers,
    required this.totalPosts,
    this.authorCount,
    this.revisionCount,
  });

  final int totalFollowers;
  final int totalPosts;
  final int? authorCount;
  final int? revisionCount;

}