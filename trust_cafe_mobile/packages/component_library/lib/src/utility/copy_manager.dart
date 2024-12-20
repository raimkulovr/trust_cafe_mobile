import 'package:super_clipboard/super_clipboard.dart';

import 'extract_text_from_html.dart';

enum CopyManagerType{
  html,
  text,
}

abstract class CopyManager{
  static Future<void> copy(String content, {required CopyManagerType type}) async {
    final clipboard = SystemClipboard.instance;
    if (clipboard == null) {
      return; // Clipboard API is not supported on this platform.
    }
    final item = DataWriterItem();
    if(type == CopyManagerType.html){
      item.add(Formats.htmlText(content));
      item.add(Formats.plainText(extractPlainText(content)));
    } else if(type == CopyManagerType.text){
      item.add(Formats.plainText(content));
    }
    await clipboard.write([item]);
  }
}