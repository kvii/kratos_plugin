/// Kratos 错误类型。在调用 http 接口时，若响应码非 200 则
/// 响应体一定是该类型的 json 数据。
class KratosError {
  /// 创建 kratos 错误。
  const KratosError({
    required this.code,
    required this.reason,
    required this.message,
    required this.metadata,
  });

  /// 响应码，与服务端响应码一致。
  ///
  /// 客户端应直接判断 http 响应码，不应与该字段交互。
  final int code;

  /// 错误原因，该原因为可枚举的字符串，
  /// 可供开发者判断错误类型。
  final String reason;

  /// 错误说明，供用户界面展示用。
  final String message;

  /// 元信息。
  final Map<String, String> metadata;

  /// 将 json 对象转换为错误类型。
  factory KratosError.fromJson(Map<String, dynamic> json) {
    return KratosError(
      code: json['code'] as int,
      reason: json['reason'] as String,
      message: json['message'] as String,
      metadata: Map<String, String>.from(json['metadata'] as Map),
    );
  }

  /// 将错误转换为 json 对象。
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'reason': reason,
      'message': message,
      'metadata': metadata,
    };
  }
}
