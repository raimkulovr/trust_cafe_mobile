import 'package:equatable/equatable.dart';

class SpiderFetchData extends Equatable {
  const SpiderFetchData({
    required this.title,
    required this.screenshot,
    this.cachedImage,
    this.description,
  });

  final String title;
  final String screenshot;
  final String? cachedImage;
  final String? description;

  @override
  List<Object?> get props => [title, screenshot, cachedImage, description];

}