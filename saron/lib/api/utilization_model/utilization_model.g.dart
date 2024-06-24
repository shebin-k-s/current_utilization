// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UtilizationModel _$UtilizationModelFromJson(Map<String, dynamic> json) =>
    UtilizationModel(
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      unitConsumed: (json['unitConsumed'] as num?)?.toDouble(),
      deviceName: json['deviceName'] as String?,
    );

Map<String, dynamic> _$UtilizationModelToJson(UtilizationModel instance) =>
    <String, dynamic>{
      'deviceName': instance.deviceName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'unitConsumed': instance.unitConsumed,
    };
