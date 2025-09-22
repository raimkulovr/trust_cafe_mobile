import 'package:json_annotation/json_annotation.dart';
import 'package:trust_cafe_api/src/models/models.dart';

part 'react_to_response_model.g.dart';

@JsonSerializable(createToJson: false)
class ReactToResponseModel {
  const ReactToResponseModel({
    required this.actionTaken,
    required this.reactions,
  });

  final String actionTaken;
  final ReactionsResponseModel reactions;

  static const fromJson = _$ReactToResponseModelFromJson;

}
