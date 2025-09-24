// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_credentials_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCredentialsResponseModel _$AuthCredentialsResponseModelFromJson(
        Map<String, dynamic> json) =>
    AuthCredentialsResponseModel(
      userData: const AppUserResponseModelConverter()
          .fromJson(json['userData'] as Map<String, dynamic>),
      tokenData: TokenDataResponseModel.fromJson(
          json['tokenData'] as Map<String, dynamic>),
    );
