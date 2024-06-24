import 'package:json_annotation/json_annotation.dart';
import 'package:saron/api/utilization_model/utilization_model.dart';

part 'get_all_utilization.g.dart';

@JsonSerializable()
class GetAllUtilization {
  @JsonKey(name: 'utilization')
  List<UtilizationModel> utilization;

  GetAllUtilization({this.utilization = const []});

  factory GetAllUtilization.fromJson(Map<String, dynamic> json) {
    return _$GetAllUtilizationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GetAllUtilizationToJson(this);
}
