import 'package:hive/hive.dart';

part 'spider_fetch_data_cache_model.g.dart';

@HiveType(typeId: 21)
class SpiderFetchDataCacheModel {
  const SpiderFetchDataCacheModel({
    required this.title,
    required this.screenshot,
    this.cachedImage,
    this.description,
  });

  @HiveField(0)
  final String title;
  @HiveField(1)
  final String screenshot;
  @HiveField(2)
  final String? cachedImage;
  @HiveField(3)
  final String? description;

}