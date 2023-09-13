import 'package:kratos_plugin/src/parse.dart';

/// http 请求参数定义。对各个 http 客户端的适配工作应该在各个工程中完成。
class RequestArg {
  /// 请求 url，没有 schema 和 host 部分。
  final Uri url;

  /// 过滤后的请求参数。
  ///
  /// 因为请求参数可能部分会被编码到 url 中。
  /// 官方规定上送参数应该不包含这部分被编码的参数。
  final Map<String, dynamic> body;

  /// 创建请求参数。
  const RequestArg({required this.body, required this.url});

  /// 根据请求路径模板创建请求参数。
  ///
  /// 期望 [req] 是由 grpc message 对象生成的 json 对象。
  ///
  /// 在 [rule.path] 路径模板中出现的参数会进行非空校验，当参数为空时会抛出异常。
  /// 应用应该在调用本函数前对参数进行校验，不要依赖于这个特性。
  ///
  /// 参考: https://cloud.google.com/endpoints/docs/grpc-service-config/reference/rpc/google.api#google.api.HttpRule
  factory RequestArg.fromPattern(HttpRule rule, Map<String, dynamic> req) {
    final arg = flatArg(req);
    final path = parsePathTemplate(rule.path, arg);
    final body = parseBody(rule.body, req, arg);

    final url = Uri(
      path: path,
      queryParameters: arg.isEmpty ? null : arg,
    );

    return RequestArg(body: body, url: url);
  }
}

/// http 路由规则。
class HttpRule {
  /// 请求类型
  final String kind;

  /// 路径模板
  final String path;

  /// 请求体
  final String body;

  /// 创建 http 路由规则。
  const HttpRule({
    required this.kind,
    required this.path,
    required this.body,
  });
}
