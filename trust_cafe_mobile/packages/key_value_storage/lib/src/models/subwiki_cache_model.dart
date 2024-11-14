import '../../key_value_storage.dart';

part 'subwiki_cache_model.g.dart';

@HiveType(typeId: 24)
class SubwikiCacheModel {
  const SubwikiCacheModel({
    required this.sk,
    required this.pk,
    required this.slug,
    required this.subwikiLabel,
    required this.subwikiDesc,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    this.subwikiLang,
    this.authors,
    this.createdByUser,
    this.branchIcon,
    this.orderedListAName,
    this.orderedListAValue,
  });

  @HiveField(1)
  final String slug;
  @HiveField(2)
  final String subwikiLabel;
  @HiveField(3)
  final String subwikiDesc;
  @HiveField(4)
  final int createdAt;
  @HiveField(5)
  final int updatedAt;
  @HiveField(6)
  final SubwikiStatisticsCacheModel statistics;
  @HiveField(7)
  final String? subwikiLang;
  @HiveField(8)
  final List<AuthorCacheModel>? authors;
  @HiveField(9)
  final AuthorCacheModel? createdByUser;
  @HiveField(10)
  final String? branchIcon;
  @HiveField(11)
  final String sk;
  @HiveField(12)
  final String pk;
  @HiveField(13)
  final String? orderedListAName;
  @HiveField(14)
  final double? orderedListAValue;

}

@HiveType(typeId: 25)
class SubwikiStatisticsCacheModel {
  const SubwikiStatisticsCacheModel({
    required this.totalFollowers,
    required this.totalPosts,
    this.authorCount,
    this.revisionCount,
  });

  @HiveField(1)
  final int totalFollowers;
  @HiveField(2)
  final int totalPosts;
  @HiveField(3)
  final int? authorCount;
  @HiveField(4)
  final int? revisionCount;

}