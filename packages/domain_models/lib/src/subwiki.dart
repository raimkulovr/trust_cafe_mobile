import 'package:equatable/equatable.dart';

import '../domain_models.dart';

class Subwiki extends Equatable {
  const Subwiki({
    required this.slug,
    required this.label,
    required this.description,
    required this.createdAt,
    required this.statistics,
    required this.branchColor,
    required this.branchId,
    required this.isFollowing,
    this.lang,
    this.createdByUser,
    this.branchIcon,
  });

  final String slug;
  final String label;
  final String description;
  final int createdAt;
  final SubwikiStatistics statistics;
  final String branchColor;
  final String branchId;
  final bool isFollowing;
  final String? lang;
  final Author? createdByUser;
  final String? branchIcon;

  @override
  List<Object?> get props =>
      [
        slug,
        label,
        description,
        createdAt,
        statistics,
        branchColor,
        branchId,
        isFollowing,
        lang,
        createdByUser,
        branchIcon,
      ];

  @override
  String toString() => label;
}

class SubwikiStatistics extends Equatable {
  const SubwikiStatistics({
    required this.totalFollowers,
    required this.totalPosts,
    this.authorCount,
    this.revisionCount,
  });

  final int totalFollowers;
  final int totalPosts;
  final int? authorCount;
  final int? revisionCount;

  @override
  List<Object?> get props =>
      [totalFollowers, totalPosts, authorCount, revisionCount,];

}