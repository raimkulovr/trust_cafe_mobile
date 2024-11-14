import 'package:equatable/equatable.dart';

import '../domain_models.dart';

class Subwiki extends Equatable {
  const Subwiki({
    required this.sk,
    required this.pk,
    required this.slug,
    required this.label,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    this.lang,
    this.authors,
    this.createdByUser,
    this.branchIcon,
    this.orderedListAName,
    this.orderedListAValue,
  });

  final String sk;
  final String pk;
  final String slug;
  final String label;
  final String description;
  final int createdAt;
  final int updatedAt;
  final SubwikiStatistics statistics;
  final String? lang;
  final List<Author>? authors;

  final Author? createdByUser;
  final String? branchIcon;
  final String? orderedListAName;
  final double? orderedListAValue;

  @override
  List<Object?> get props =>
      [
        sk,
        pk,
        slug,
        label,
        description,
        createdAt,
        updatedAt,
        statistics,
        lang,
        authors,
        createdByUser,
        branchIcon,
        orderedListAName,
        orderedListAValue,
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