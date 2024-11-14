import 'package:hive/hive.dart';
import 'package:key_value_storage/src/models/subwiki_cache_model.dart';

part 'subwiki_list_cache_model.g.dart';

@HiveType(typeId: 23)
class SubwikiListCacheModel{
  const SubwikiListCacheModel({
    required this.subwikiList,
    required this.timestamp,
  });

  @HiveField(1)
  final List<SubwikiCacheModel> subwikiList;
  @HiveField(2)
  final DateTime timestamp;

}