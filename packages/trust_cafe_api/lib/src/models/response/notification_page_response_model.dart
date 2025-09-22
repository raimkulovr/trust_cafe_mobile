import 'package:json_annotation/json_annotation.dart';

import 'last_evaluated_key_response_model.dart';
import 'notification_details_response_model.dart';

part 'notification_page_response_model.g.dart';

@JsonSerializable(createToJson: false)
class NotificationPageResponseModel{
  const NotificationPageResponseModel({
    required this.notificationList,
    this.lastEvaluatedKey,
  });

  @JsonKey(name: 'Items')
  final List<NotificationDetailsResponseModel> notificationList;

  @JsonKey(name: 'LastEvaluatedKey')
  final LastEvaluatedKeyResponseModel? lastEvaluatedKey;

  static const fromJson = _$NotificationPageResponseModelFromJson;

}