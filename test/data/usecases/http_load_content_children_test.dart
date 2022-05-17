import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tab_news/data/data.dart';
import 'package:tab_news/domain/domain.dart';

import 'http_load_content_children_test.mocks.dart';

class HttpLoadContentChildren {
  final String url;
  final MockHttpClient httpClient;

  HttpLoadContentChildren({required this.url, required this.httpClient});

  Future<void> loadContentChildren(String contentId) async {
    await httpClient.request(url: url, method: 'get');
  }
}

@GenerateMocks([HttpClient])
void main() {
  late HttpLoadContentChildren sut;
  late MockHttpClient httpClient;
  late String url;
  late List<Map> list;

  Map createJsonContent({List<Map> children = const []}) => {
        'id': faker.guid.guid(),
        'owner_id': faker.randomGenerator.string(50),
        'parent_id': faker.randomGenerator.string(50),
        'slug': faker.randomGenerator.string(20),
        'title': null,
        'body': faker.randomGenerator.string(250),
        'status': 'published',
        'source_url': null,
        'created_at': faker.date.dateTime().toIso8601String(),
        'updated_at': faker.date.dateTime().toIso8601String(),
        'published_at': faker.date.dateTime().toIso8601String(),
        'username': faker.randomGenerator.string(10),
        'parent_title': faker.randomGenerator.string(50),
        'parent_slug': faker.randomGenerator.string(20),
        'parent_username': faker.randomGenerator.string(10),
        'children': children,
      };

  List<Map> mockValidData() => [
        createJsonContent(),
        createJsonContent(children: [createJsonContent(), createJsonContent()]),
        createJsonContent(),
      ];

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(List<Map> data) {
    list = data;
    mockRequest().thenAnswer((_) async => data);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = MockHttpClient();
    sut = HttpLoadContentChildren(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test('Should call HttpClient with correct values', () async {
    sut.loadContentChildren(faker.guid.guid());

    verify(httpClient.request(url: url, method: 'get')).called(1);
  });
}
