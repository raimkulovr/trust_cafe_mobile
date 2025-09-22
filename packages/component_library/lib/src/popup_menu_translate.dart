import 'package:flutter/material.dart';

class PopUpMenuTranslate extends StatelessWidget {
  const PopUpMenuTranslate({super.key,});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // Icon(Icons.translate, color: Colors.blue,),
        Expanded(child: Text('Translate')), //TODO: l10n
      ],
    );
  }
}
