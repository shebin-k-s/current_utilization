import 'package:json_annotation/json_annotation.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  @JsonKey(name: 'deviceId')
  int? deviceId;

  @JsonKey(name: 'serialNumber')
  String? serialNumber;

  @JsonKey(name: 'deviceOn')
  bool? deviceOn;

  @JsonKey(name: 'deviceName')
  String? deviceName;

  Device({this.deviceId, this.serialNumber, this.deviceOn, this.deviceName});

  factory Device.fromJson(Map<String, dynamic> json) {
    return _$DeviceFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
