import 'package:json_annotation/json_annotation.dart';

part 'errors.g.dart';

/// Kratos 错误类型。在调用 http 接口时，若响应码非 200 则
/// 响应体一定是该类型的 json 数据。
@JsonSerializable()
class KratosError {
  const KratosError({
    required this.code,
    required this.reason,
    required this.message,
    required this.metadata,
  });

  /// 响应码，与服务端响应码一致。
  /// 客户端应直接判断 http 响应码，不应与该字段交互。
  final int code;

  /// 错误原因，该原因为可枚举的字符串，
  /// 可供开发着判断错误类型。
  final String reason;

  /// 错误说明，供用户界面展示用。
  final String message;

  /// 元信息。
  final Map<String, String> metadata;

  factory KratosError.fromJson(Map<String, dynamic> json) {
    return _$KratosErrorFromJson(json);
  }

  Map<String, dynamic> toJson() => _$KratosErrorToJson(this);
}
