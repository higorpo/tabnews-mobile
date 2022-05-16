import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter({required this.client});

  dynamic request({
    required String url,
    required String method,
    Map? body,
    Map? headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });

    return await client.get(Uri.parse(url), headers: defaultHeaders);
  }
}

@GenerateMocks([Client])
void main() {
  late Client client;
  late Uri uri;

  PostExpectation mockRequest() => when(client.get(uri, headers: anyNamed('headers')));

  void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
    mockRequest().thenAnswer((_) async => Response(body, statusCode));
  }

  setUp(() {
    client = MockClient();
    uri = Uri.parse(faker.internet.httpUrl());

    mockResponse(200);
  });

  test('Should call get with correct values', () async {
    final sut = HttpAdapter(client: client);

    await sut.request(url: uri.toString(), method: 'get');

    verify(
      client.get(
        uri,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
      ),
    ).called(1);
  });
}
