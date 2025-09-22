import 'package:hive_ce/hive.dart';

class TranslationCacheModel extends HiveObject {
  TranslationCacheModel({
    required this.itemId,
    required this.sourceHash,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.translatedText,
  });

  String itemId;
  String sourceHash;
  String sourceLanguage;
  String targetLanguage;
  String translatedText;

}
