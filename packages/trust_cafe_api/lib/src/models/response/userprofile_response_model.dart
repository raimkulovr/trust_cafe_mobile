import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/response/trust_level_info_converter.dart';

part 'userprofile_response_model.g.dart';

@JsonSerializable(createToJson: false)
class UserprofileResponseModel {
  UserprofileResponseModel({
    required this.fname,
    required this.userLanguage,
    required this.lname,
    required this.userId,
    required this.slug,
    required this.userBio,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    this.trustLevel = 0,
    this.trustName = '',
    this.membershipType,
    this.blocked = false,
    this.admin = false,
  });

  final String fname;
  @JsonKey(name: 'userlanguage')
  final String? userLanguage;
  final String lname;
  @JsonKey(name: 'userID')
  final String userId;
  final String slug;

  final String? userBio;
  final int createdAt;
  final int updatedAt;
  final UserprofileStatisticsResponseModel statistics;
  final double? trustLevel;
  @TrustLevelInfoConverter()
  @JsonKey(name: 'trustLevelInfo')
  final String? trustName;
  final String? membershipType;
  final bool? admin;
  final bool? blocked;

  static const fromJson = _$UserprofileResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class UserprofileStatisticsResponseModel{
  const UserprofileStatisticsResponseModel({
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

  static const fromJson = _$UserprofileStatisticsResponseModelFromJson;

}