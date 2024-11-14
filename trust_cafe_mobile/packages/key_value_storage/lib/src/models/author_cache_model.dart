import 'package:hive/hive.dart';

part 'author_cache_model.g.dart';
@HiveType(typeId: 2)
class AuthorCacheModel {
  const AuthorCacheModel({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    this.trustLevel,
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
  @HiveField(5)
  final double? trustLevel;
  @HiveField(6)
  final String? trustName;
  @HiveField(7)
  final String? membershipType;
}