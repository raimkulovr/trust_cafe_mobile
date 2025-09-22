import 'package:json_annotation/json_annotation.dart';

part 'last_evaluated_key_response_model.g.dart';

@JsonSerializable(createToJson: false)
class LastEvaluatedKeyResponseModel{
  const LastEvaluatedKeyResponseModel({
    required this.pk,
    required this.sk,
  });
  final String pk;
  final String sk;

  static const fromJson = _$LastEvaluatedKeyResponseModelFromJson;

  @override
  String toString({bool subwiki = false, bool yourFeed = false}) =>
      yourFeed
        ? 'start=$sk'
        : subwiki
          ? 'pk=$pk'
          : 'sk=$sk&pk=$pk';
}
