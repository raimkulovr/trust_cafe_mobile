import 'package:equatable/equatable.dart';

class TrustObject extends Equatable{
  const TrustObject({
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

  @override
  List<Object?> get props => [
    trustLevel,
    pk,
    sk,
    updatedAt,
    createdAt,
  ];

}