// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPageResponseModel _$NotificationPageResponseModelFromJson(
        Map<String, dynamic> json) =>
    NotificationPageResponseModel(
      notificationList: (json['Items'] as List<dynamic>)
          .map((e) => NotificationDetailsResponseModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      lastEvaluatedKey: json['LastEvaluatedKey'] == null
          ? null
          : LastEvaluatedKeyResponseModel.fromJson(
              json['LastEvaluatedKey'] as Map<String, dynamic>),
    );
