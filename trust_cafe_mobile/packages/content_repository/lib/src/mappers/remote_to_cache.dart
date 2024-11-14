import 'package:content_repository/src/mappers/domain_to_cache.dart';
import 'package:content_repository/src/mappers/remote_to_domain.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';

extension SubwikiResponseToCM on SubwikiDetailsResponseModel {
  SubwikiCacheModel get toCacheModel =>
      SubwikiCacheModel(
        sk: sk,
        pk: pk,
        slug: slug,
        subwikiLabel: subwikiLabel,
        subwikiDesc: subwikiDesc ?? subwikiDescription ?? '',
        createdAt: createdAt,
        updatedAt: updatedAt,
        statistics: statistics.toCacheModel,
        subwikiLang: subwikiLang,
        authors: authors?.map((e) => e.toDomainModel.toCacheModel,).toList(),
        createdByUser: createdByUser?.toDomainModel.toCacheModel,
        branchIcon: branchIcon,
        orderedListAName: orderedListAName,
        orderedListAValue: orderedListAValue,
      );
}

extension SubwikiStatisticsResponseToCM on SubwikiStatisticsResponseModel {
  SubwikiStatisticsCacheModel get toCacheModel =>
      SubwikiStatisticsCacheModel(totalFollowers: totalFollowers, totalPosts: totalPosts, authorCount: authorCount, revisionCount: revisionCount);
}

