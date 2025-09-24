// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenDataResponseModel _$TokenDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    TokenDataResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      accessTimeOut: (json['accessTimeOut'] as num).toInt(),
    );
