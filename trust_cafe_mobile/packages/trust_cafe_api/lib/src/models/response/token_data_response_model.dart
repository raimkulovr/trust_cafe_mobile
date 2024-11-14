import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:trust_cafe_api/src/models/api_token_data.dart';

part 'token_data_response_model.g.dart';

@JsonSerializable(createToJson: false)
class TokenDataResponseModel extends ApiTokenData{
  const TokenDataResponseModel(
      {
        required super.accessToken,
        required super.refreshToken,
        required super.accessTimeOut,
      });

  static const fromJson = _$TokenDataResponseModelFromJson;

}
