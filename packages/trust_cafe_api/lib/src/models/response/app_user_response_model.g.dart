// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUserResponseModel _$AppUserResponseModelFromJson(
        Map<String, dynamic> json) =>
    AppUserResponseModel(
      userId: json['userID'] as String,
      slug: json['slug'] as String,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      userLanguage: json['userlanguage'] as String,
      groups:
          (json['groups'] as List<dynamic>).map((e) => e as String).toList(),
      trustLevelInfo: TrustLevelInfoResponseModel.fromJson(
          json['trustLevelInfo'] as Map<String, dynamic>),
      voteValue: (json['votevalue'] as num).toInt(),
    );

TrustLevelInfoResponseModel _$TrustLevelInfoResponseModelFromJson(
        Map<String, dynamic> json) =>
    TrustLevelInfoResponseModel(
      aka: json['aka'] as String,
      trustLevelInt: (json['trustLevelInt'] as num).toInt(),
    );

AppUserVoteResponseModel _$AppUserVoteResponseModelFromJson(
        Map<String, dynamic> json) =>
    AppUserVoteResponseModel(
      parent: AppUserVoteParentResponseModel.fromJson(
          json['parent'] as Map<String, dynamic>),
      vote: json['vote'] as String,
    );

AppUserVoteParentResponseModel _$AppUserVoteParentResponseModelFromJson(
        Map<String, dynamic> json) =>
    AppUserVoteParentResponseModel(
      sk: json['sk'] as String,
      pk: json['pk'] as String,
    );
