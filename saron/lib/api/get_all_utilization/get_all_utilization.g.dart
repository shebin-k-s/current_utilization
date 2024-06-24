// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_utilization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllUtilization _$GetAllUtilizationFromJson(Map<String, dynamic> json) =>
    GetAllUtilization(
      utilization: (json['utilization'] as List<dynamic>?)
              ?.map((e) => UtilizationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GetAllUtilizationToJson(GetAllUtilization instance) =>
    <String, dynamic>{
      'utilization': instance.utilization,
    };
