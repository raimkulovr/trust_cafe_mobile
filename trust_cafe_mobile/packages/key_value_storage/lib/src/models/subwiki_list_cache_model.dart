import 'package:hive_ce/hive.dart';

import 'package:key_value_storage/src/models/subwiki_cache_model.dart';

class SubwikiListCacheModel extends HiveObject {
  SubwikiListCacheModel({
    required this.subwikiList,
    required this.timestamp,
  });

  final List<SubwikiCacheModel> subwikiList;
  final DateTime timestamp;

}