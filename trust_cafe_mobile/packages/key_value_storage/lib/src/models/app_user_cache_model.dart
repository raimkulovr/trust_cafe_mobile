import 'package:hive/hive.dart';

part 'app_user_cache_model.g.dart';

@HiveType(typeId: 0)
class AppUserCacheModel{
  const AppUserCacheModel({
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

  @HiveField(0)
  final String userId;
  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String fname;
  @HiveField(3)
  final String lname;
  @HiveField(4)
  final String userLanguage;
  @HiveField(5)
  final List<String> groups;
  @HiveField(6)
  final String trustLevelInfo;
  @HiveField(7)
  final int voteValue;
  @HiveField(8)
  final int trustLevelInt;

}

@HiveType(typeId: 16)
class UserVoteCacheModel {
  const UserVoteCacheModel({
    required this.parentSk,
    required this.parentPk,
    required this.isUp,
  });

  @HiveField(1)
  final String parentSk;
  @HiveField(2)
  final String parentPk;
  @HiveField(3)
  final bool isUp;
}