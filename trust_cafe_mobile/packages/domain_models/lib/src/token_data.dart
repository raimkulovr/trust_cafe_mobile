import 'package:equatable/equatable.dart';
class TokenData extends Equatable{
  const TokenData({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTimeOut,
  });

  final String accessToken;
  final String refreshToken;
  final int accessTimeOut;

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    accessTimeOut,
  ];
}