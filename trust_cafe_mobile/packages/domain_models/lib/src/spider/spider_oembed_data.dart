import 'package:equatable/equatable.dart';

class SpiderOembedData extends Equatable {
  const SpiderOembedData({
    required this.type,
    required this.title,
    required this.thumbnailUrl,
    required this.providerName,
    required this.html,
    this.authorName,
    this.authorUrl,
  });

  final String type;
  final String title;
  final String? thumbnailUrl;
  final String providerName;
  final String html;
  final String? authorName;
  final String? authorUrl;

  @override
  List<Object?> get props =>
      [authorName, authorUrl, type, title, thumbnailUrl, providerName, html,];

}