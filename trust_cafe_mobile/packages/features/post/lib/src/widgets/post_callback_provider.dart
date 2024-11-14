import 'package:component_library/typedefs.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

class PostCallbackProvider extends InheritedWidget {
  final GetAppUserCallback getAppUser;
  final Function(Post post, {bool shouldScrollToSlug}) showComments;
  final String? Function() scrollToSlug;

  const PostCallbackProvider({super.key,
    required this.getAppUser,
    required this.showComments,
    required this.scrollToSlug,
    required super.child,
  });

  static PostCallbackProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PostCallbackProvider>();
  }

  static PostCallbackProvider of(BuildContext context) {
    final PostCallbackProvider? result = maybeOf(context);
    assert(result != null, 'No PostCallbackProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(PostCallbackProvider oldWidget) {
    return false;
  }
}