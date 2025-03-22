import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

QuillEditorConfig getEditorConfig({
  required ColorScheme colorScheme,
}){
  return QuillEditorConfig(
    placeholder: 'What\'s on your mind?',
    padding: const EdgeInsets.all(8),
    keyboardAppearance: colorScheme.brightness,
    embedBuilders: [
      QuillEditorImageEmbedBuilder(
        config: QuillEditorImageEmbedConfig(
          imageProviderBuilder: (context, url)=>getImageProviderByImageSource(url),
          imageErrorWidgetBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red, size: 56,);
          },
        ),
      ),
    ],
  );
}