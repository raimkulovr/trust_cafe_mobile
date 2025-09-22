import 'package:flutter/material.dart';

class LinkPreviewEditor extends StatefulWidget {
  const LinkPreviewEditor({
    required this.onSaved,
    this.initialText,
    super.key,
  });

  final void Function(String) onSaved;
  final String? initialText;

  @override
  State<LinkPreviewEditor> createState() => _LinkPreviewEditorState();
}

class _LinkPreviewEditorState extends State<LinkPreviewEditor> {
  late final TextEditingController _textFieldController;

  @override
  void initState() {
    _textFieldController = TextEditingController(text: widget.initialText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final maxSize = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text('Set link for preview'),
      content: SizedBox(
        width: maxSize.width*0.9,
        child: TextField(
          controller: _textFieldController,
          maxLines: 10,
          decoration: const InputDecoration(hintText: "Enter link"),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            widget.onSaved(_textFieldController.text);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }
}