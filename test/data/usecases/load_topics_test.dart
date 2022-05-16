import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tab_news/data/http/http.dart';

import 'load_topics_test.mocks.dart';

class HttpLoadTopics {
  final String url;
  final HttpClient httpClient;

  HttpLoadTopics({required this.url, required this.httpClient});

  Future<void> loadAllTopics() async {
    await httpClient.request(url: url, method: 'get');
  }
}

@GenerateMocks([HttpClient])
void main() {
  test('Should call HttpClient with correct values', () async {
    final String url = faker.internet.httpUrl();
    final httpClient = MockHttpClient();
    final sut = HttpLoadTopics(url: url, httpClient: httpClient);

    when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'))).thenAnswer((_) async => Future.value(null));

    sut.loadAllTopics();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });
}
