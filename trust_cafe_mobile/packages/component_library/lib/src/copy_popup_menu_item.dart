import 'package:flutter/material.dart';
import 'copy_manager.dart';

class CopyPopupMenuItem extends PopupMenuItem<void Function()> {
  CopyPopupMenuItem(String content, {super.key})
      : super(
      value: () async {
        await CopyManager.copy(content, type: CopyManagerType.html);
      },
      child: const Text('Copy text')
  );
}
