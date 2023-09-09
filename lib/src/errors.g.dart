// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KratosError _$KratosErrorFromJson(Map<String, dynamic> json) => KratosError(
      code: json['code'] as int,
      reason: json['reason'] as String,
      message: json['message'] as String,
      metadata: Map<String, String>.from(json['metadata'] as Map),
    );

Map<String, dynamic> _$KratosErrorToJson(KratosError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'reason': instance.reason,
      'message': instance.message,
      'metadata': instance.metadata,
    };
