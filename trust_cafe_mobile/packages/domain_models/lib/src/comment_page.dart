import 'package:domain_models/src/page.dart';
import '../domain_models.dart';

class CommentPage extends Page{
  const CommentPage({
    required this.commentList,
    super.pageKey,
    super.nextPageKey,
  });

  final List<Comment> commentList;

  @override
  List<Object?> get props => [
    ...super.props,
    commentList,
  ];

}