import 'package:equatable/equatable.dart';

class Userprofile {
  const Userprofile({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    required this.userBio,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    this.trustLevel = 0,
    this.trustName,
    this.membershipType,
    this.admin,
  });

  final String fname;
  final String? userLanguage;
  final String lname;
  final String userId;
  final String slug;
  final String userBio;
  final bool? admin;
  final bool blocked;
  final int createdAt;
  final int updatedAt;
  final UserprofileStatistics statistics;
  final double? trustLevel;
  final String? trustName;
  final String? membershipType;

  String get fullName => '$fname $lname';

  @override
  List<Object?> get props =>
      [
        fname,
        userLanguage,
        lname,
        userId,
        slug,
        trustLevel,
        trustName,
        membershipType,
        userBio,
        blocked,
        createdAt,
        updatedAt,
        statistics,
        admin,
      ];
}

class UserprofileStatistics extends Equatable {
  const UserprofileStatistics({
    this.authorCount,
    this.commentCount,
    this.postCount,
    this.revisionCount,
    this.subwikiCount,
    this.totalFollowers,
    this.totalProfilePosts,
  });

  final int? authorCount;
  final int? commentCount;
  final int? postCount;
  final int? revisionCount;
  final int? subwikiCount;
  final int? totalFollowers;
  final int? totalProfilePosts;

  @override
  List<Object?> get props =>
      [
        authorCount,
        commentCount,
        postCount,
        revisionCount,
        subwikiCount,
        totalFollowers,
        totalProfilePosts,
      ];

}