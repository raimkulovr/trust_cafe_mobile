import 'package:super_clipboard/super_clipboard.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' hide Text;

String extractPlainText(String htmlString) {
  Document document = html_parser.parse(htmlString);
  String plainText = document.body?.text ?? '';
  return plainText;
}

enum CopyManagerType{
  html,
  text,
}

abstract class CopyManager{
  static Future<void> copy(String content, {required CopyManagerType type}) async {
    // print(content);
    // return;
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