import 'package:hive/hive.dart';
part 'translation_cache_model.g.dart';

@HiveType(typeId: 17)
class TranslationCacheModel {
  TranslationCacheModel({
    required this.itemId,
    required this.sourceHash,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.translatedText,
  });

  @HiveField(0)
  String itemId;
  @HiveField(1)
  String sourceHash;
  @HiveField(2)
  String sourceLanguage;
  @HiveField(3)
  String targetLanguage;
  @HiveField(4)
  String translatedText;

}
