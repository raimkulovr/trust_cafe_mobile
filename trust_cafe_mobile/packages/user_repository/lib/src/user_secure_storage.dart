import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _accessTokenKey = 'trust-cafe-access-token';
  static const _refreshTokenKey = 'trust-cafe-refresh-token';
  static const _accessTimeoutKey = 'trust-cafe-access-timeout';

  const UserSecureStorage({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  Future<void> upsertTokenData({
    required String accessToken,
    required String refreshToken,
    required int accessTimeOut,
  }) =>
      Future.wait([
        _secureStorage.write(
          key: _accessTokenKey,
          value: accessToken,
        ),
        _secureStorage.write(
          key: _refreshTokenKey,
          value: refreshToken,
        ),
        _secureStorage.write(
          key: _accessTimeoutKey,
          value: accessTimeOut.toString(),
        ),
      ]);

  Future<List<String?>> getTokenData() => Future.wait<String?>([
        _secureStorage.read(key: _accessTokenKey),
        _secureStorage.read(key: _refreshTokenKey),
        _secureStorage.read(key: _accessTimeoutKey),
      ]);

  Future<void> deleteTokenData() => _secureStorage.deleteAll();
}
