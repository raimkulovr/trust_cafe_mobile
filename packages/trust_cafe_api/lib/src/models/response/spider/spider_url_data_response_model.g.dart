// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spider_url_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpiderUrlDataResponseModel _$SpiderUrlDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    SpiderUrlDataResponseModel(
      url: json['url'] as String?,
      expiresAt: (json['expires_at'] as num?)?.toInt(),
      fetchData: json['fetch_data'] == null
          ? null
          : SpiderFetchDataResponseModel.fromJson(
              json['fetch_data'] as Map<String, dynamic>),
      oembedData: json['oembed_data'] == null
          ? null
          : SpiderOembedDataResponseModel.fromJson(
              json['oembed_data'] as Map<String, dynamic>),
    );
