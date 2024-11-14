import 'post_cache_model.dart';
import 'package:hive/hive.dart';

part 'post_page_cache_model.g.dart';

@HiveType(typeId: 9)
class PostPageCacheModel{
  const PostPageCacheModel({
    required this.postList,
    this.pageKey,
    this.nextPageKey,
  });

  @HiveField(0)
  final List<String> postList;
  @HiveField(1)
  final String? pageKey;
  @HiveField(2)
  final String? nextPageKey;

}