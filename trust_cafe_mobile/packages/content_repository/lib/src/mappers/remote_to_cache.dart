import 'package:content_repository/src/mappers/domain_to_cache.dart';
import 'package:content_repository/src/mappers/remote_to_domain.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';

extension SubwikiResponseToCM on SubwikiDetailsResponseModel {
  SubwikiCacheModel get toCacheModel =>
      SubwikiCacheModel(
        slug: slug,
        subwikiLabel: subwikiLabel,
        subwikiDesc: branchSummary,
        createdAt: createdAt,
        statistics: statistics.toCacheModel,
        subwikiLang: subwikiLang,
        createdByUser: null,
        branchIcon: branchIcon,
        branchColor: branchColor,
        branchId: branchID,
        isFollowing: isFollowing,
      );
}

extension SubwikiStatisticsResponseToCM on SubwikiStatisticsResponseModel {
  SubwikiStatisticsCacheModel get toCacheModel =>
      SubwikiStatisticsCacheModel(totalFollowers: totalFollowers, totalPosts: totalPosts, authorCount: authorCount, revisionCount: revisionCount);
}

