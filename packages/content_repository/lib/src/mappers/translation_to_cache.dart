import 'package:content_repository/src/hash_generator.dart';
import 'package:key_value_storage/key_value_storage.dart';
import 'package:translator/translator.dart';

extension TranslationToCM on Translation {
  TranslationCacheModel toCacheModel(String itemId) =>
      TranslationCacheModel(
          itemId: itemId,
          sourceHash: HashGenerator.generateMd5Hash(source),
          sourceLanguage: sourceLanguage.name,
          targetLanguage: targetLanguage.name,
          translatedText: text,
      );
}
