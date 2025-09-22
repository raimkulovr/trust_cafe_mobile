import 'package:hive_ce/hive.dart';

class SpiderFetchDataCacheModel extends HiveObject {
  SpiderFetchDataCacheModel({
    required this.title,
    required this.screenshot,
    this.cachedImage,
    this.description,
  });

  final String title;
  final String screenshot;
  final String? cachedImage;
  final String? description;

}