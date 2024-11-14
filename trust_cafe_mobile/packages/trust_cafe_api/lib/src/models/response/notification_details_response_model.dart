import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/models.dart';

part 'notification_details_response_model.g.dart';

@JsonSerializable(createToJson: false)
class NotificationDetailsResponseModel{
  const NotificationDetailsResponseModel({
    required this.createdAt,
    required this.updatedAt,
    required this.sk,
    required this.pk,
    required this.item,
  });

  final int createdAt;
  final int? updatedAt;
  final String sk;
  final String pk;
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

  @InitiatorInfoConverter()
  final AuthorResponseModel initiator;
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

class InitiatorInfoConverter
    extends JsonConverter<AuthorResponseModel, Map<String, dynamic>> {
  const InitiatorInfoConverter();

  @override
  AuthorResponseModel fromJson(Map<String, dynamic> json) {
    if(json['userID']=='WTS2'){
      return AuthorResponseModel(fname: 'SYSTEM', userLanguage: null, lname: 'SYSTEM', userId: 'SYSTEM', slug: 'SYSTEM');
    } else {
      return AuthorResponseModel.fromJson(json);
    }
  }

  @Deprecated('Technically not intended to be used since this converter is only used for deserialization.')
  @override
  Map<String, dynamic> toJson(AuthorResponseModel object) {
    throw UnimplementedError();
  }
}