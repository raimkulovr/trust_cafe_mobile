import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/models.dart';
import 'package:trust_cafe_api/src/models/response/trust_level_info_converter.dart';

part 'userprofile_response_model.g.dart';

@JsonSerializable(createToJson: false)
class UserprofileResponseModel extends AuthorResponseModel {
  UserprofileResponseModel({
    required super.fname,
    required super.userLanguage,
    required super.lname,
    required super.userId,
    required super.slug,
    required this.userBio,
    required this.createdAt,
    required this.updatedAt,
    required this.statistics,
    super.trustLevel,
    super.trustName,
    super.membershipType,
    this.blocked,
    this.admin,
  });

  final String? userBio;
  final bool? admin;
  final bool? blocked;
  final int createdAt;
  final int updatedAt;
  final UserprofileStatisticsResponseModel statistics;

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