import 'package:hive_ce/hive.dart';

import 'spider_fetch_data_cache_model.dart';
import 'spider_oembed_data_cache_model.dart';


class SpiderUrlDataCacheModel extends HiveObject {
  SpiderUrlDataCacheModel({
    required this.url,
    required this.expiresAt,
    this.fetchData,
    this.oembedData,
  });

  final String url;
  final int expiresAt;
  final SpiderFetchDataCacheModel? fetchData;
  final SpiderOembedDataCacheModel? oembedData;
}
