// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userprofile_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserprofileResponseModel _$UserprofileResponseModelFromJson(
        Map<String, dynamic> json) =>
    UserprofileResponseModel(
      fname: json['fname'] as String,
      userLanguage: json['userlanguage'] as String?,
      lname: json['lname'] as String,
      userId: json['userID'] as String,
      slug: json['slug'] as String,
      userBio: json['userBio'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      statistics: UserprofileStatisticsResponseModel.fromJson(
          json['statistics'] as Map<String, dynamic>),
      trustLevel: (json['trustLevel'] as num?)?.toDouble(),
      trustName: _$JsonConverterFromJson<Map<String, dynamic>, String>(
          json['trustLevelInfo'], const TrustLevelInfoConverter().fromJson),
      membershipType: json['membershipType'] as String?,
      blocked: json['blocked'] as bool?,
      admin: json['admin'] as bool?,
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

UserprofileStatisticsResponseModel _$UserprofileStatisticsResponseModelFromJson(
        Map<String, dynamic> json) =>
    UserprofileStatisticsResponseModel(
      authorCount: (json['authorCount'] as num?)?.toInt(),
      commentCount: (json['commentCount'] as num?)?.toInt(),
      postCount: (json['postCount'] as num?)?.toInt(),
      revisionCount: (json['revisionCount'] as num?)?.toInt(),
      subwikiCount: (json['subwikiCount'] as num?)?.toInt(),
      totalFollowers: (json['totalFollowers'] as num?)?.toInt(),
      totalProfilePosts: (json['totalProfilePosts'] as num?)?.toInt(),
    );
