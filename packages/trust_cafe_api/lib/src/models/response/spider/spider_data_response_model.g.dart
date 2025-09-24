// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spider_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpiderDataResponseModel _$SpiderDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    SpiderDataResponseModel(
      source: json['source'] as String,
      urlData: SpiderUrlDataResponseModel.fromJson(
          json['urldata'] as Map<String, dynamic>),
    );
