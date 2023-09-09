import 'package:path/path.dart' as p;

/// 将 [arg] "拍平"。[arg] 期望为 message 类型生成的 json 对象。
/// 由于参数期望层数很低，所以用递归实现。
/// 返回 map 的值类型为 String | List<String>
Map<String, dynamic> flatArg(Map<String, dynamic> arg) {
  final out = <String, dynamic>{};
  _flat(arg, out, '');
  return out;
}

/// 递归函数体。不考虑 Any 等特殊情况。
void _flat(Map<String, dynamic> arg, Map<String, dynamic> out, String pre) {
  arg.forEach((key, value) {
    if (value == null) {
      return;
    }
    if (value is List) {
      out[pre + key] = [for (final e in value) e.toString()];
      return;
    }
    if (value is Map<String, dynamic>) {
      _flat(value, out, '$pre$key.');
      return;
    }
    out[pre + key] = value.toString();
  });
}

/// 路由参数解析。
/// [path] 为路径参数模板。
/// [arg] 为请求参数，子类型已经被压缩成类似 "foo.bar" 的格式。
///
/// 本函数只支持以下语法规则：
/// * "{field}" 和 "{sub.field}" 格式的变量段。
/// * LITERAL 路由段。
///
/// 全部语法规则：
///
/// ```
/// Template = "/" Segments [ Verb ] ;
/// Segments = Segment { "/" Segment } ;
/// Segment  = "*" | "**" | LITERAL | Variable ;
/// Variable = "{" FieldPath [ "=" Segments ] "}" ;
/// FieldPath = IDENT { "." IDENT } ;
/// Verb     = ":" LITERAL ;
/// ````
///
/// 参考: https://cloud.google.com/endpoints/docs/grpc-service-config/reference/rpc/google.api#path-template-syntax
String parsePathTemplate(String path, Map<String, dynamic> arg) {
  final list = p.url.split(path);

  final parts = <String>[];
  for (final e in list) {
    final v = RegExp(r'^{(.+)}$').firstMatch(e)?.group(1);
    if (v != null) {
      parts.add(arg.remove(v) as String);
    } else {
      parts.add(e);
    }
  }
  return p.url.joinAll(parts);
}

/// 请求体过滤。不考虑特殊情况。
Map<String, dynamic> parseBody(
  String body,
  Map<String, dynamic> req,
  Map<String, dynamic> arg,
) {
  switch (body) {
    case "":
      return {};
    case "*":
      final m = Map.of(arg);
      arg.clear();
      return m;
    default:
      arg.remove(body);
      return {body: req[body]};
  }
}
