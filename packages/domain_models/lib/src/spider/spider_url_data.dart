import 'package:domain_models/src/spider/spider_fetch_data.dart';
import 'package:domain_models/src/spider/spider_oembed_data.dart';
import 'package:equatable/equatable.dart';

class SpiderUrlData extends Equatable {
  const SpiderUrlData({
    required this.url,
    required this.expiresAt,
    this.fetchData,
    this.oembedData,
  });

  final String url;
  final int expiresAt; //MILLISECONDS since epoch

  final SpiderFetchData? fetchData;
  final SpiderOembedData? oembedData;

  bool get isEmpty => fetchData == null && oembedData == null;

  @override
  List<Object?> get props => [url, expiresAt, fetchData, oembedData];

}
