import 'package:domain_models/src/page.dart';

import 'post.dart';

class PostPage extends Page{
  const PostPage({
    required this.postList,
    super.pageKey,
    super.nextPageKey,
  });

  final List<Post> postList;

  @override
  List<Object?> get props => [
    ...super.props,
    postList,
  ];

}