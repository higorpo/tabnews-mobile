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
  late HttpLoadTopics sut;
  late MockHttpClient httpClient;
  late String url;
  late List<Map> list;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'owner_id': faker.randomGenerator.string(50),
          'parent_id': null,
          'slug': faker.randomGenerator.string(20),
          'title': faker.randomGenerator.string(20),
          'body': faker.randomGenerator.string(250),
          'status': 'published',
          'source_url': null,
          'created_at': faker.date.dateTime().toIso8601String(),
          'updated_at': faker.date.dateTime().toIso8601String(),
          'published_at': faker.date.dateTime().toIso8601String(),
          'username': faker.randomGenerator.string(10),
          'parent_title': null,
          'parent_slug': null,
          'parent_username': null,
        },
        {
          'id': faker.guid.guid(),
          'owner_id': faker.randomGenerator.string(50),
          'parent_id': null,
          'slug': faker.randomGenerator.string(20),
          'title': faker.randomGenerator.string(20),
          'body': faker.randomGenerator.string(250),
          'status': 'published',
          'source_url': null,
          'created_at': faker.date.dateTime().toIso8601String(),
          'updated_at': faker.date.dateTime().toIso8601String(),
          'published_at': faker.date.dateTime().toIso8601String(),
          'username': faker.randomGenerator.string(10),
          'parent_title': null,
          'parent_slug': null,
          'parent_username': null,
        },
      ];

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = HttpLoadTopics(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    sut.loadAllTopics();

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });
}
