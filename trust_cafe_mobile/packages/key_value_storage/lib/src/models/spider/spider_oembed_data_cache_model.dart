import 'package:hive/hive.dart';

part 'spider_oembed_data_cache_model.g.dart';

@HiveType(typeId: 22)
class SpiderOembedDataCacheModel {
  const SpiderOembedDataCacheModel({
    required this.type,
    required this.title,
    required this.thumbnailUrl,
    required this.providerName,
    required this.html,
    this.authorName,
    this.authorUrl,
  });

  @HiveField(0)
  final String type;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? thumbnailUrl;
  @HiveField(3)
  final String providerName;
  @HiveField(4)
  final String html;
  @HiveField(5)
  final String? authorName;
  @HiveField(6)
  final String? authorUrl;


}