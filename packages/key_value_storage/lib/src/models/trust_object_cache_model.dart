import 'package:hive_ce/hive.dart';

class TrustObjectCacheModel extends HiveObject {
  TrustObjectCacheModel({
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

}