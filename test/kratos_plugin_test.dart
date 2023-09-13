import 'dart:convert';

import 'package:kratos_plugin/kratos_plugin.dart';
import 'package:test/test.dart';

void main() {
  group('request arg', () {
    test('from pattern', () {
      final req = RequestArg.fromPattern(
        HttpRule(
          kind: "get",
          path: '/hello/{name}',
          body: "",
        ),
        {
          'name': 'foo',
        },
      );

      expect(req.url.toString(), '/hello/foo');
      expect(req.body, {});
    });

    test('with query', () {
      final req = RequestArg.fromPattern(
        HttpRule(
          kind: 'get',
          path: '/hello/{name}',
          body: "",
        ),
        {
          'name': 'foo',
          'age': 18,
          'tags': ['a', 'b'],
          'flag': true,
          'sub': {'field': 'bar'},
          'zero': null,
        },
      );

      expect(
        req.url.toString(),
        '/hello/foo?age=18&tags=a&tags=b&flag=true&sub.field=bar',
      );
      expect(req.body, {});
    });

    test('with body', () {
      final req = RequestArg.fromPattern(
        HttpRule(
          kind: 'post',
          path: '/hello/{name}',
          body: "age",
        ),
        {
          'name': 'foo',
          'age': 18,
          'addr': 'Earth',
        },
      );

      expect(req.url.toString(), '/hello/foo?addr=Earth');
      expect(req.body, {'age': 18});
    });

    test('missing path variable', () {
      expect(
        () => RequestArg.fromPattern(
          HttpRule(
            kind: 'get',
            path: '/hello/{name}',
            body: "",
          ),
          {
            "name": "",
          },
        ),
        throwsArgumentError,
      );
    });
  });

  group('kratos error', () {
    test('encode', () {
      const body = '{"code":400,"reason":"foo","message":"bar","metadata":{}}';
      final error = KratosError(
        code: 400,
        reason: 'foo',
        message: 'bar',
        metadata: {},
      );
      expect(jsonEncode(error.toJson()), body);
    });

    test('decode', () {
      const body = '{"code":400,"reason":"foo","message":"bar","metadata":{}}';
      final error = KratosError.fromJson(jsonDecode(body));
      expect(error.code, 400);
      expect(error.reason, 'foo');
      expect(error.message, 'bar');
      expect(error.metadata, {});
    });
  });
}
