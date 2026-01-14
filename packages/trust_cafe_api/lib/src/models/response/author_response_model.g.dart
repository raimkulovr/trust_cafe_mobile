// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorResponseModel _$AuthorResponseModelFromJson(Map<String, dynamic> json) =>
    AuthorResponseModel(
      fname: json['fname'] as String,
      userLanguage: json['userlanguage'] as String?,
      lname: json['lname'] as String,
      userId: json['userID'] as String,
      slug: json['slug'] as String,
      trustLevel: json['trustLevel'] == null
          ? ''
          : const StringDoubleNullConverter().fromJson(json['trustLevel']),
      trustName: _$JsonConverterFromJson<Map<String, dynamic>, String>(
          json['trustLevelInfo'], const TrustLevelInfoConverter().fromJson),
      membershipType: json['membershipType'] as String?,
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
