
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import '../regular_expressions/regular_expressions.dart';
import '../typedefs.dart';

QuillSimpleToolbarConfig getToolbarConfig({
  required TextEditorDestination destination,
  required FocusNode focusNode,
}){
  return QuillSimpleToolbarConfig(
      showClipboardCut: true,
      showClipboardCopy: true,
      showClipboardPaste: true,
      showUndo: false,
      showRedo: false,
      showFontFamily: false,
      showFontSize: false,
      showSubscript: false,
      showSuperscript: false,
      showColorButton: false,
      showBackgroundColorButton: false,
      showListNumbers: false,
      showListBullets: false,
      showListCheck: false,
      showCodeBlock: false,
      showInlineCode: false,
      showIndent: false,
      showStrikeThrough: false,
      showQuote: destination==TextEditorDestination.post,
      showHeaderStyle: destination==TextEditorDestination.post,
      headerStyleType: HeaderStyleType.original,
      buttonOptions: QuillSimpleToolbarButtonOptions(
        base: QuillToolbarBaseButtonOptions(
            afterButtonPressed: focusNode.requestFocus
        ),
        selectHeaderStyleDropdownButton: QuillToolbarSelectHeaderStyleDropdownButtonOptions(
            attributes: [
              Attribute.h1,
              Attribute.h2,
              Attribute.h3,
              Attribute.h4,
              Attribute.h5,
              Attribute.h6,
              Attribute.header,
            ]
        ),
      ),
      embedButtons: FlutterQuillEmbeds.toolbarButtons(
        videoButtonOptions: null,
        cameraButtonOptions: null,
        imageButtonOptions: QuillToolbarImageButtonOptions(
          linkRegExp: postHtmlExp,
        ),
      )
  );
}