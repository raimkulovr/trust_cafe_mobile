import 'package:trust_cafe_api/src/trust_cafe_api.dart';

class InvalidRefreshTokenTCApiException implements Exception {}
class NoRightsToPerformActionTCApiException implements Exception{}

/// Thrown if [TrustCafeApi]'s request methods called before setting
/// the [TokenData] property.
class TokenNotSetTCApiException implements Exception{}

class ServerNotAvailableTCApiException implements Exception{}