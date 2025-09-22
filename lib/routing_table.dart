import 'dart:developer';

import 'package:trust_cafe_mobile/features/auth/auth.dart';
import 'package:component_library/component_library.dart';
import 'package:content_repository/content_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:trust_cafe_mobile/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:trust_cafe_mobile/features/post/post.dart';
import 'package:trust_cafe_mobile/features/changes/changes.dart';
import 'package:routemaster/routemaster.dart';
import 'package:settings/settings.dart';
import 'package:trust_cafe_mobile/tab_container_screen.dart';
import 'package:user_repository/user_repository.dart';

Map<String, PageBuilder> buildRoutingTable({
  required AppUser appUser,
  required UserRepository userRepository,
  required ContentRepository contentRepository,
}) {
  return {
    PathConstants.tabContainerPath: (_) => CupertinoTabPage(
          child: TabContainerView(appUser),
          paths: [
            PathConstants.feedPath,
            if(appUser.isNotGuest) PathConstants.advancedPath,
            PathConstants.settingsPath,
          ],
        ),
    PathConstants.feedPath: (_) {
      return MaterialPage(
        name: 'home-screen',
          // maintainState: false,
        child: Builder(
          builder: (context) {
            final routerDelegate = Routemaster.of(context);
            return HomeScreen(
              appUser: appUser,
              userRepository: userRepository,
              contentRepository: contentRepository,
              onAuthenticationRequest: (context) {
                routerDelegate.push(PathConstants.authPath);
              },
            );
          }
        )
      );
    },
    PathConstants.settingsPath: (_) {
      return MaterialPage(
          name: 'settings-screen',
          child: SettingsScreen(userRepository: userRepository,));
    },
    PathConstants.authPath: (_) {
      return MaterialPage(
        name: 'auth-screen',
        maintainState: false,
        child: AuthScreen(userRepository: userRepository,),
      );
    },
    PathConstants.advancedPath: (_) {
      return MaterialPage(
        name: 'advanced-screen',
        child: Builder(
          builder: (context) {
            return ChangesScreen(
              appUser: appUser,
              userRepository: userRepository,
              contentRepository: contentRepository,
            );
          }),
      );
    },
    '${PathConstants.tabContainerPath}post/:postId': (info) {
      final postId = info.pathParameters['postId'];
      final commentSlug = info.queryParameters[PathConstants.scrollToSlugKey];
      return MaterialPage(
        key: ValueKey(postId),
        name: 'post-screen',
        child: PostScreen(
          post: null,
          postId: postId,
          scrollToSlug: (commentSlug?.isNotEmpty ?? false) ? commentSlug : null,
          userRepository: userRepository,
          contentRepository: contentRepository,
          appUser: appUser,
        ),
      );
    }
  };
}
