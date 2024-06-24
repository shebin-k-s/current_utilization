import 'package:json_annotation/json_annotation.dart';

part 'utilization_model.g.dart';

@JsonSerializable()
class UtilizationModel {

  @JsonKey(name: 'deviceName')
  String? deviceName;

  @JsonKey(name: 'startDate')
  String? startDate;

  @JsonKey(name: 'endDate')
  String? endDate;

  @JsonKey(name: 'unitConsumed')
  double? unitConsumed;

  UtilizationModel({
    this.startDate,
    this.endDate,
    this.unitConsumed,
    this.deviceName
  });

  UtilizationModel.create({
    required this.startDate,
    required this.endDate,
    required this.unitConsumed,
    required this.deviceName
  });

  factory UtilizationModel.fromJson(Map<String, dynamic> json) {
    return _$UtilizationModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UtilizationModelToJson(this);
}
