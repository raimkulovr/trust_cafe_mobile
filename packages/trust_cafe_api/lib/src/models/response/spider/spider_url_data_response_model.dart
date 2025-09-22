import 'package:json_annotation/json_annotation.dart';

import 'spider_fetch_data_response_model.dart';
import 'spider_oembed_data_response_model.dart';

part 'spider_url_data_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SpiderUrlDataResponseModel{
  const SpiderUrlDataResponseModel({
    this.url,
    this.expiresAt,
    this.fetchData,
    this.oembedData,
  });

  final String? url;

  @JsonKey(name: 'expires_at')
  final int? expiresAt;
  @JsonKey(name: 'fetch_data')
  final SpiderFetchDataResponseModel? fetchData;
  @JsonKey(name: 'oembed_data')
  final SpiderOembedDataResponseModel? oembedData;

  bool get isEmpty => fetchData==null && oembedData==null;

  static const fromJson = _$SpiderUrlDataResponseModelFromJson;

}
