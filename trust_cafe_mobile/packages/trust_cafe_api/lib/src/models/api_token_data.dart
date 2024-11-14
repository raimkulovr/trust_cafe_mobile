import 'package:equatable/equatable.dart';

class ApiTokenData extends Equatable{
  const ApiTokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTimeOut,
  });

  final String accessToken;
  final String refreshToken;
  final int accessTimeOut;
  DateTime get tokenExpiryDate => DateTime.fromMillisecondsSinceEpoch(accessTimeOut);
  bool get isNotExpired => accessToken=='guest' || tokenExpiryDate.isAfter(DateTime.now());
  bool get isEmpty => this == ApiTokenData.empty;
  static const empty = ApiTokenData(accessToken: '', refreshToken: '', accessTimeOut: 0);

  @override
  String toString() {
    return 'ApiTokenData{accessToken: $accessToken, refreshToken: $refreshToken, accessTimeOut: $accessTimeOut}';
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    accessTimeOut,
  ];
}
