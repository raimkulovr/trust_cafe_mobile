import 'package:hive_ce/hive.dart';

class SpiderOembedDataCacheModel extends HiveObject {
  SpiderOembedDataCacheModel({
    required this.type,
    required this.title,
    required this.thumbnailUrl,
    required this.providerName,
    required this.html,
    this.authorName,
    this.authorUrl,
  });

  final String type;
  final String title;
  final String? thumbnailUrl;
  final String providerName;
  final String html;
  final String? authorName;
  final String? authorUrl;
}