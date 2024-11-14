import 'package:json_annotation/json_annotation.dart';
import 'spider_url_data_response_model.dart';

part 'spider_data_response_model.g.dart';

@JsonSerializable(createToJson: false)
class SpiderDataResponseModel{
  const SpiderDataResponseModel({
    required this.source,
    required this.urlData,
  });

  final String source; //"fetch" or "cache"
  @JsonKey(name: 'urldata')
  final SpiderUrlDataResponseModel urlData;

  static const fromJson = _$SpiderDataResponseModelFromJson;

}