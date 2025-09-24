// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trust_object_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrustObjectResponseModel _$TrustObjectResponseModelFromJson(
        Map<String, dynamic> json) =>
    TrustObjectResponseModel(
      trustLevel: (json['trustLevel'] as num).toInt(),
      pk: json['pk'] as String,
      sk: json['sk'] as String,
      updatedAt: (json['updatedAt'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
    );
