import 'package:flutter/material.dart';

import '../component_library.dart';

class ConfirmLinkNavigationDialog extends StatelessWidget {
  const ConfirmLinkNavigationDialog(this.url, {super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    final  colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Do you want to continue?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('You\'re about to navigate to: '),
            SelectionArea(child: Text(url, style: TextStyle(color: colorScheme.primary,),)),
            // const Text('Do you want to continue?'),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: ()=>Navigator.of(context).pop(false), child: const Text('Cancel')),
        TcmPrimaryButton(onPressed: ()=>Navigator.of(context).pop(true), text: 'Continue'),
      ],
    );
  }
}
