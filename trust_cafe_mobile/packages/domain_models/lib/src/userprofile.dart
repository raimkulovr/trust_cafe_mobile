import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class Userprofile extends Author {
  const Userprofile({
    required String fname,
    required String? userLanguage,
    required String lname,
    required String userId,
    required String slug,
    double? trustLevel,
    String? trustName,
    String? membershipType,
    required this.userBio,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    this.admin,
  }) : super.internal(fname: fname, userLanguage: userLanguage, lname: lname, userId: userId, slug: slug,
      trustLevel: trustLevel,
      trustName: trustName,
      membershipType: membershipType,
  );

  final String userBio;
  final bool? admin;
  final bool blocked;
  final int createdAt;
  final int updatedAt;
  final UserprofileStatistics statistics;

  @override
  List<Object?> get props =>
      [
        ...super.props,
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