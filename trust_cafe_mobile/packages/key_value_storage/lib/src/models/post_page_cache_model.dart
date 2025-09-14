import 'package:hive_ce/hive.dart';

class PostPageCacheModel extends HiveObject {
  PostPageCacheModel({
    required this.postList,
    this.pageKey,
    this.nextPageKey,
  });

  final List<String> postList;
  final String? pageKey;
  final String? nextPageKey;

}