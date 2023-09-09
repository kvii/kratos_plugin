import 'package:kratos_plugin/kratos_plugin.dart';

void main() {
  final arg = RequestArg.fromPattern(
    HttpRule(
      kind: 'get',
      path: '/hello/{name}',
      body: '',
    ),
    {
      'name': 'foo',
    },
  );

  print(arg.url); // /hello/foo
  print(arg.body); // {}
}
