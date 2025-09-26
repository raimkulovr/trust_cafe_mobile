// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDetailsResponseModel _$NotificationDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    NotificationDetailsResponseModel(
      createdAt: (json['createdAt'] as num).toInt(),
      item: NotificationDetailsItemResponseModel.fromJson(
          json['item'] as Map<String, dynamic>),
    );

NotificationDetailsItemResponseModel
    _$NotificationDetailsItemResponseModelFromJson(Map<String, dynamic> json) =>
        NotificationDetailsItemResponseModel(
          initiator: NotificationInitiatorResponseModel.fromJson(
              json['initiator'] as Map<String, dynamic>),
          read: json['read'] as bool,
          reason: json['reason'] as String,
          replacements:
              NotificationDetailsItemReplacementsResponseModel.fromJson(
                  json['replacements'] as Map<String, dynamic>),
        );

NotificationDetailsItemReplacementsResponseModel
    _$NotificationDetailsItemReplacementsResponseModelFromJson(
            Map<String, dynamic> json) =>
        NotificationDetailsItemReplacementsResponseModel(
          postLink: json['postLink'] as String?,
          postSnippet: json['postSnippet'] as String?,
          newLevel: json['newLevel'] as String?,
          ratingPercentage: (json['ratingPercentage'] as num?)?.toInt(),
          commentLink: json['commentLink'] as String?,
          commentSnippet: json['commentSnippet'] as String?,
        );

NotificationInitiatorResponseModel _$NotificationInitiatorResponseModelFromJson(
        Map<String, dynamic> json) =>
    NotificationInitiatorResponseModel(
      name: json['name'] as String,
      userLanguage: json['userlanguage'] as String?,
      userId: json['userID'] as String,
      slug: json['slug'] as String,
      trustName: _$JsonConverterFromJson<Map<String, dynamic>, String>(
          json['trustLevelInfo'], const TrustLevelInfoConverter().fromJson),
    );

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
