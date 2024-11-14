import 'package:hive/hive.dart';

part 'trust_object_cache_model.g.dart';

@HiveType(typeId: 19)
class TrustObjectCacheModel {
  const TrustObjectCacheModel({
    required this.trustLevel,
    required this.pk,
    required this.sk,
    required this.updatedAt,
    required this.createdAt,
  });

  @HiveField(0)
  final int trustLevel;
  @HiveField(1)
  final String pk;
  @HiveField(2)
  final String sk;
  @HiveField(3)
  final int updatedAt;
  @HiveField(4)
  final int createdAt;

}