import 'package:json_annotation/json_annotation.dart';

import 'device.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  @JsonKey(name: 'devices')
  List<Device>? devices;

  DeviceModel({this.devices});

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return _$DeviceModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}
