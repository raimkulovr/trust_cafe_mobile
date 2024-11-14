import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';

import '../component_library.dart';

abstract class UrlLauncher{
  static Future<void> launchWebUrl(BuildContext context, String url, {
    OnPostOpenedCallback? onPostOpened,
    bool preventOnFailedMatch = false,
  }) async {
    //TODO: domain sensitive regexp
    final regExp = RegExp(r'post\/(?:post#)?(\d+-[a-zA-Z0-9]+)');
    final match = regExp.firstMatch(url);
    if (match != null) {
      late final String comment;
      final splitUrl = url.split('#comment-');
      if(splitUrl.isNotEmpty && splitUrl.last!=url){
        comment = splitUrl.last;
      } else {
        comment = '';
      }

      final extractedPart = match.group(1)!;
      if(onPostOpened!=null){
        onPostOpened(extractedPart);
      } else {
        final routerDelegate = Routemaster.of(context);
        routerDelegate.push(PathConstants.postDetailsPath(postId: extractedPart),
            queryParameters: {PathConstants.scrollToSlugKey: comment});
      }
    } else {
      if(preventOnFailedMatch) {
        log('failed match: {$url}. preventing navigation');
        return;
      }

      final navigate = await showDialog(context: context, builder: (context) {
        return ConfirmLinkNavigationDialog(url);
      },) ?? false;

      if (navigate && !await launchUrl(Uri.parse(url))) {
        log('Could not launch $url');
      }
    }
  }
}