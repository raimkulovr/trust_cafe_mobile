import 'package:json_annotation/json_annotation.dart';

import 'trust_level_info_converter.dart';

part 'notification_details_response_model.g.dart';

@JsonSerializable(createToJson: false)
class NotificationDetailsResponseModel{
  const NotificationDetailsResponseModel({
    required this.createdAt,
    required this.item,
  });

  final int createdAt;
  final NotificationDetailsItemResponseModel item;

  static const fromJson = _$NotificationDetailsResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class NotificationDetailsItemResponseModel{
  const NotificationDetailsItemResponseModel({
    required this.initiator,
    required this.read,
    required this.reason,
    required this.replacements,
  });

  final NotificationInitiatorResponseModel initiator;
  final bool read;
  final String reason;
  final NotificationDetailsItemReplacementsResponseModel replacements;

  static const fromJson = _$NotificationDetailsItemResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class NotificationDetailsItemReplacementsResponseModel{
  const NotificationDetailsItemReplacementsResponseModel({
    this.postLink,
    this.postSnippet,
    this.newLevel,
    this.ratingPercentage,
    this.commentLink,
    this.commentSnippet,
  });

  final String? postLink;
  final String? postSnippet;
  final String? newLevel;
  final int? ratingPercentage;
  final String? commentLink;
  final String? commentSnippet;

  static const fromJson = _$NotificationDetailsItemReplacementsResponseModelFromJson;

}

@JsonSerializable(createToJson: false)
class NotificationInitiatorResponseModel {
  const NotificationInitiatorResponseModel({
    required this.name,
    required this.userLanguage,
    required this.userId,
    required this.slug,
    this.trustName,
  });

  final String name;
  @JsonKey(name: 'userlanguage')
  final String? userLanguage;
  @JsonKey(name: 'userID')
  final String userId;
  final String slug;
  @TrustLevelInfoConverter()
  @JsonKey(name: 'trustLevelInfo')
  final String? trustName;

  static const fromJson = _$NotificationInitiatorResponseModelFromJson;
}
