import 'package:component_library/src/utility/extract_text_from_html.dart';
import 'package:flutter/services.dart';

enum CopyManagerType{
  html,
  text,
}

abstract class CopyManager{
  static Future<void> copy(String content, {required CopyManagerType type}) async {
    return await Clipboard.setData(ClipboardData(
        text: type == CopyManagerType.text ? content : extractPlainText(content),
    ));
  }
}