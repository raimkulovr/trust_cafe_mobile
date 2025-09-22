import 'package:flutter/material.dart';

import '../component_library.dart';

class GoToButton extends StatelessWidget {
  const GoToButton(this.slug, {
    required this.isBranch,
    required this.isProduction,
    super.key});

  final bool isBranch;
  final String slug;
  final bool isProduction;

  @override
  Widget build(BuildContext context) {

    final url = '${'https://${isProduction ? 'www.trustcafe.io' : 'alpha.wts2.net'}/en/'}'
        '${isBranch ? 'wt' : 'user'}/$slug';
    return Center(
      child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          ),
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(-1.0, 1.0),
            child: Icon(Icons.reply, size: 14, applyTextScaling: true,),
          ),
          onPressed: () {
            UrlLauncher.launchWebUrl(context, url);
          },
          iconAlignment: IconAlignment.end,
          label: Text('Go to ${isBranch ? 'branch':'profile'}')),
    );
  }
}
