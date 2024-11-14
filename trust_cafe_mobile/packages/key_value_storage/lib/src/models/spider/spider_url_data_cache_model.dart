import 'package:hive/hive.dart';

import 'spider_fetch_data_cache_model.dart';
import 'spider_oembed_data_cache_model.dart';

part 'spider_url_data_cache_model.g.dart';

@HiveType(typeId: 20)
class SpiderUrlDataCacheModel {
  const SpiderUrlDataCacheModel({
    required this.url,
    required this.expiresAt,
    this.fetchData,
    this.oembedData,
  });

  @HiveField(0)
  final String url;
  @HiveField(1)
  final int expiresAt;
  @HiveField(2)
  final SpiderFetchDataCacheModel? fetchData;
  @HiveField(3)
  final SpiderOembedDataCacheModel? oembedData;


}
