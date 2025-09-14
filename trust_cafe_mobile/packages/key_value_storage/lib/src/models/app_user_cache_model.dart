import 'package:hive_ce/hive.dart';

class AppUserCacheModel extends HiveObject {
  AppUserCacheModel({
    required this.userId,
    required this.slug,
    required this.fname,
    required this.lname,
    required this.userLanguage,
    required this.groups,
    required this.trustLevelInfo,
    required this.voteValue,
    required this.trustLevelInt,
  });

  final String userId;
  final String slug;
  final String fname;
  final String lname;
  final String userLanguage;
  final List<String> groups;
  final String trustLevelInfo;
  final int voteValue;
  final int trustLevelInt;

}

class UserVoteCacheModel extends HiveObject {
  UserVoteCacheModel({
    required this.parentSk,
    required this.parentPk,
    required this.isUp,
  });

  final String parentSk;
  final String parentPk;
  final bool isUp;
}