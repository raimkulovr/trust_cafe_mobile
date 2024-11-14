import 'package:equatable/equatable.dart';

abstract class Page extends Equatable{
  const Page({
    this.pageKey,
    this.nextPageKey,
  });

  ///if this is [null], then this page is the first page.
  final String? pageKey;
  //sk&pk
  final String? nextPageKey;

  bool get isFirstPage => pageKey == null;
  bool get isLastPage => nextPageKey == null;

  @override
  List<Object?> get props => [
    pageKey,
    nextPageKey
  ];

}