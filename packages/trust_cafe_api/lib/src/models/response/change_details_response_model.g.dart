// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_details_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeDetailsResponseModel _$ChangeDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChangeDetailsResponseModel(
      changeLabel: json['changeLabel'] as String?,
      action: json['action'] as String,
      slug: json['slug'] as String,
      uri: json['uri'] as String,
      createdAt: (json['createdAt'] as num).toInt(),
      changeText: json['changeText'] as String,
      author: const ChangeDataUserConverter()
          .fromJson(json['data'] as Map<String, dynamic>),
      changeTextData: ChangeTextDataResponseModel.fromJson(
          json['changeTextData'] as Map<String, dynamic>),
    );

ChangeTextDataResponseModel _$ChangeTextDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    ChangeTextDataResponseModel(
      type: json['type'] as String,
      entity: json['entity'] as String,
    );
