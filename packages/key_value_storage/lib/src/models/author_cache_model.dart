import 'package:hive_ce/hive.dart';

class AuthorCacheModel extends HiveObject {
  AuthorCacheModel({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    this.trustLevel,
    this.trustName,
    this.membershipType,
  });

  final String fname;
  final String? userLanguage;
  final String lname;
  final String userId;
  final String slug;
  final double? trustLevel;
  final String? trustName;
  final String? membershipType;
}