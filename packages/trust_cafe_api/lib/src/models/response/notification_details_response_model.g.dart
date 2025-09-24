// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDetailsResponseModel _$NotificationDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    NotificationDetailsResponseModel(
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num?)?.toInt(),
      sk: json['sk'] as String,
      pk: json['pk'] as String,
      item: NotificationDetailsItemResponseModel.fromJson(
          json['item'] as Map<String, dynamic>),
    );

NotificationDetailsItemResponseModel
    _$NotificationDetailsItemResponseModelFromJson(Map<String, dynamic> json) =>
        NotificationDetailsItemResponseModel(
          initiator: const InitiatorInfoConverter()
              .fromJson(json['initiator'] as Map<String, dynamic>),
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
