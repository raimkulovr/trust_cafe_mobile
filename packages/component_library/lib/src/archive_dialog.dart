import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

enum ArchiveType{
  post,
  comment,
}

class ArchiveDialog extends StatelessWidget {
  const ArchiveDialog({super.key,
    required this.type,
    required this.contentText,
    required this.onArchive,
    required this.imageSizeThreshold,
    required this.author,
  });

  final String contentText;
  final VoidCallback onArchive;
  final double? imageSizeThreshold;
  final Author author;
  final ArchiveType type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Archive this ${type==ArchiveType.post ? 'post' : 'comment'}?'), //TODO: l10n
      content: SingleChildScrollView(
        child: Column(
            children: [
              Text('${author.fullName} says:'),
              ExpandableHtmlWidget(
                html: contentText,
                isExpanded: true,
                horizontalPadding: 0,
                imageSizeThreshold: imageSizeThreshold,
                allowSelection: false,
                // interceptImages: false,
              ),
            ]
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              onArchive();
              Navigator.of(context).pop();
            },
            child: const Text('Archive', style: TextStyle(color: Colors.red),)
        ),
      ],
    );
  }

}
