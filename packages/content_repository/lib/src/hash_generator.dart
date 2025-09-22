import 'dart:convert';
import 'package:crypto/crypto.dart';

abstract class HashGenerator{
  static String generateMd5Hash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}