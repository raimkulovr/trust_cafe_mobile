import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

String extractPlainText(String htmlString) {
  Document document = html_parser.parse(htmlString);
  String plainText = document.body?.text ?? '';
  return plainText;
}