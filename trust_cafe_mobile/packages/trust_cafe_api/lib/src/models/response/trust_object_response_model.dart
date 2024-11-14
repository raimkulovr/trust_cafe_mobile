import 'package:json_annotation/json_annotation.dart';

part 'trust_object_response_model.g.dart';

@JsonSerializable(createToJson: false)
class TrustObjectResponseModel {
  const TrustObjectResponseModel({
    required this.trustLevel,
    required this.pk,
    required this.sk,
    required this.updatedAt,
    required this.createdAt,
  });

  final int trustLevel;
  final String pk;
  final String sk;
  final int updatedAt;
  final int createdAt;

  static const fromJson = _$TrustObjectResponseModelFromJson;

}