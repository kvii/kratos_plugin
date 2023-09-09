Runtime support for kratos dart http client.

## Features

* 根据 google.api.http 注解生成 http 请求参数。
* 提供 kratos http 接口返回错误的定义。

## Getting started

由 proto 文件:

```proto
service Greeter {
  rpc SayHello (HelloRequest) returns (HelloReply) {
    option (google.api.http) = {
      get: "/hello/{name}"
    };
  }
}

message HelloRequest {
  string name = 1;
}
message HelloReply {
  string message = 1;
}
```

生成:

```dart
@override
Future<HelloReply> sayHello(HelloRequest req) async {
  final arg = RequestArg.fromPattern(
    const HttpRule(
      kind: "get",
      path: "/hello/{name}",
      body: "",
    ),
    req.toJson(),
  );

  final resp = await _client.get(arg.url, headers: {
    'Content-Type': 'application/json',
  });

  if (resp.statusCode >= 200 && resp.statusCode <= 299) {
    return HelloReply.fromJson(jsonDecode(resp.body));
  }
  throw KratosError.fromJson(jsonDecode(resp.body));
}
```

## Usage

```dart
import 'package:http/http.dart' as http;

final arg = RequestArg.fromPattern(
  HttpRule(
    kind: 'post',
    path: '/book/{id}',
    body: '*',
  ),
  {
    'id': 1,
    'name': 'book',
  },
);

final resp = await http.post(
  arg.url,
  headers: {
    'Content-Type': 'application/json',
  },
  body: arg.body,
);
```

## Additional information

This plugin is in-progress. It's only used for myself currently.