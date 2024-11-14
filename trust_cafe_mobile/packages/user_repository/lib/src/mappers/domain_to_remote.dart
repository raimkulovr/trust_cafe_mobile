import 'package:domain_models/domain_models.dart';
import 'package:trust_cafe_api/trust_cafe_api.dart';

extension TokenDataDomainToRM on TokenData {
  ApiTokenData get toApiModel =>
      ApiTokenData(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessTimeOut: accessTimeOut,
      );
}
