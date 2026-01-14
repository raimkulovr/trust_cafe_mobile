import 'package:hive_ce/hive.dart';

@HiveType(typeId: 2)
class AuthorCacheModel extends HiveObject {
  AuthorCacheModel({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    this.trustLevelString = '',
    this.trustName,
    this.membershipType,
  });

  @HiveField(0)
  final String fname;
  @HiveField(1)
  final String? userLanguage;
  @HiveField(2)
  final String lname;
  @HiveField(3)
  final String userId;
  @HiveField(4)
  final String slug;
  @HiveField(8)
  final String? trustLevelString;
  @HiveField(6)
  final String? trustName;
  @HiveField(7)
  final String? membershipType;
}
