import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/models.dart';
import 'package:trust_cafe_api/src/models/response/token_data_response_model.dart';

import 'package:trust_cafe_api/trust_cafe_api.dart';

import 'app_user_response_model.dart';

part 'auth_credentials_response_model.g.dart';

@JsonSerializable(createToJson: false)
class AuthCredentialsResponseModel {
  const AuthCredentialsResponseModel({
    required this.userData,
    required this.tokenData,
  });
  @AppUserResponseModelConverter()
  final AppUserResponseModel userData;
  final TokenDataResponseModel tokenData;
  static const fromJson =  _$AuthCredentialsResponseModelFromJson;
  static const guest = AuthCredentialsResponseModel(
      userData: AppUserResponseModel.guest(),
      tokenData: TokenDataResponseModel(
        accessToken: 'guest',
        refreshToken: '',
        accessTimeOut: 8640000000000000,
      ));

}

class AppUserResponseModelConverter
    extends JsonConverter<AppUserResponseModel, Map<String, dynamic>> {
  const AppUserResponseModelConverter();

  @override
  AppUserResponseModel fromJson(Map<String, dynamic> json) {
    final userId = json['userID'] as String;
    if (userId == 'guest'){
      return const AppUserResponseModel.guest();
    } else {
      return AppUserResponseModel.fromJson(json);
    }
  }

  @Deprecated('Technically not intended to be used since this converter is only used to deserialize data.')
  @override
  Map<String, dynamic> toJson(AppUserResponseModel object) {
    throw UnimplementedError();
  }
}