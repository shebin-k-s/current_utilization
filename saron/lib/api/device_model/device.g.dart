// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      deviceId: json['deviceId'] as int?,
      serialNumber: json['serialNumber'] as String?,
      deviceOn: json['deviceOn'] as bool?,
      deviceName: json['deviceName'] as String?,
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'deviceId': instance.deviceId,
      'serialNumber': instance.serialNumber,
      'deviceOn': instance.deviceOn,
      'deviceName': instance.deviceName,
    };
