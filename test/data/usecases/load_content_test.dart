import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tab_news/data/data.dart';

import 'load_contents_test.mocks.dart';

class HttpLoadContent {
  final HttpClient httpClient;
  final String url;

  HttpLoadContent({required this.httpClient, required this.url});

  Future<void> loadContent(String contentId) async {
    await httpClient.request(url: url, method: 'get');
  }
}

@GenerateMocks([HttpClient])
void main() {
  late HttpLoadContent sut;
  late MockHttpClient httpClient;
  late String url;
  late Map list;

  Map mockValidData() => {
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
      };

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(Map data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = HttpLoadContent(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    sut.loadContent(faker.guid.guid());

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });
}
