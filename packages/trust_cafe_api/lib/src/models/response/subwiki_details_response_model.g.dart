// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subwiki_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubwikiDetailsResponseModel _$SubwikiDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    SubwikiDetailsResponseModel(
      slug: json['slug'] as String,
      subwikiLabel: json['subwikiLabel'] as String,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      statistics: json['statistics'] == null
          ? const SubwikiStatisticsResponseModel()
          : SubwikiStatisticsResponseModel.fromJson(
              json['statistics'] as Map<String, dynamic>),
      subwikiLang: json['subwikiLang'] as String? ?? "",
      branchIcon: json['branchIcon'] as String? ?? "",
      branchColor: json['branchColor'] as String? ?? "",
      branchSummary: json['branchSummary'] as String? ?? "",
      branchID: json['branchID'] as String? ?? "",
      isFollowing: json['isFollowing'] as bool? ?? false,
    );

SubwikiStatisticsResponseModel _$SubwikiStatisticsResponseModelFromJson(
        Map<String, dynamic> json) =>
    SubwikiStatisticsResponseModel(
      totalFollowers: (json['totalFollowers'] as num?)?.toInt() ?? 0,
      totalPosts: (json['totalPosts'] as num?)?.toInt() ?? 0,
      authorCount: (json['authorCount'] as num?)?.toInt() ?? 0,
      revisionCount: (json['revisionCount'] as num?)?.toInt() ?? 0,
    );
