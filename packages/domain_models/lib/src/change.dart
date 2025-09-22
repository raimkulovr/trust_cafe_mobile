import 'package:equatable/equatable.dart';

import 'author.dart';

enum ChangeType {
  updated,
  created,
  unknown,
}

enum ChangeEntity {
  post,
  comment,
  userprofile,
  subwiki,
  unknown,
}

class Change extends Equatable {
  const Change({
    required this.changeLabel,
    required this.action,
    required this.slug,
    required this.uri,
    required this.createdAt,
    required this.changeText,
    required this.author,
    required this.type,
    required this.entity,
  });

  final String? changeLabel;
  final String action;
  final String slug;
  final String uri;
  final int createdAt;
  final String changeText;
  final Author author;
  final ChangeType type;
  final ChangeEntity entity;
  bool get isUnknown => type==ChangeType.unknown || entity == ChangeEntity.unknown;

  @override
  List<Object?> get props =>
      [changeLabel, action, slug, uri, createdAt, changeText, author, type, entity,];

}