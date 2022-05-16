import 'dart:convert';

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
    Map? headers,
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
      });

    final response = await client.get(Uri.parse(url), headers: defaultHeaders);

    return response.body.isNotEmpty ? jsonDecode(response.body) : null;
  }
}

@GenerateMocks([Client])
void main() {
  late HttpAdapter sut;
  late Client client;
  late Uri uri;

  PostExpectation mockRequest() => when(client.get(uri, headers: anyNamed('headers')));

  void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
    mockRequest().thenAnswer((_) async => Response(body, statusCode));
  }

  setUp(() {
    client = MockClient();
    sut = HttpAdapter(client: client);
    uri = Uri.parse(faker.internet.httpUrl());

    mockResponse(200);
  });

  test('Should call get with correct values', () async {
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

  test('Should return data if get returns 200', () async {
    final response = await sut.request(url: uri.toString(), method: 'get');

    expect(response, {'any_key': 'any_value'});
  });

  test('Should return data if get returns 200 with no data', () async {
    mockResponse(200, body: '');

    final response = await sut.request(url: uri.toString(), method: 'get');

    expect(response, null);
  });

  test('Should return null if get returns 204', () async {
    mockResponse(204, body: '');

    final response = await sut.request(url: uri.toString(), method: 'get');

    expect(response, null);
  });
}
