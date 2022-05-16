import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tab_news/data/data.dart';
import 'package:tab_news/domain/domain.dart';

import 'load_topics_test.mocks.dart';

class HttpLoadTopics {
  final String url;
  final HttpClient httpClient;

  HttpLoadTopics({required this.url, required this.httpClient});

  Future<List<TopicEntity>> loadAllTopics() async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return response.map<TopicEntity>((map) => RemoteTopicModel.fromJson(map).toEntity()).toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
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

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
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

  test('Should return topics on 200', () async {
    final topics = await sut.loadAllTopics();

    expect(
      topics,
      [
        TopicEntity(
          id: list[0]['id'],
          ownerId: list[0]['owner_id'],
          parentId: list[0]['parent_id'],
          slug: list[0]['slug'],
          title: list[0]['title'],
          body: list[0]['body'],
          status: TopicStatus.published,
          sourceUrl: list[0]['source_url'],
          createdAt: DateTime.parse(list[0]['created_at']),
          updatedAt: DateTime.parse(list[0]['updated_at']),
          publishedAt: DateTime.parse(list[0]['published_at']),
          username: list[0]['username'],
          parentTitle: list[0]['parent_title'],
          parentSlug: list[0]['parent_slug'],
          parentUsername: list[0]['parent_username'],
        ),
        TopicEntity(
          id: list[1]['id'],
          ownerId: list[1]['owner_id'],
          parentId: list[1]['parent_id'],
          slug: list[1]['slug'],
          title: list[1]['title'],
          body: list[1]['body'],
          status: TopicStatus.published,
          sourceUrl: list[1]['source_url'],
          createdAt: DateTime.parse(list[1]['created_at']),
          updatedAt: DateTime.parse(list[1]['updated_at']),
          publishedAt: DateTime.parse(list[1]['published_at']),
          username: list[1]['username'],
          parentTitle: list[1]['parent_title'],
          parentSlug: list[1]['parent_slug'],
          parentUsername: list[1]['parent_username'],
        ),
      ],
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData([
      {'invalid_key': 'invalid_data'}
    ]);

    final future = sut.loadAllTopics();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.loadAllTopics();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.loadAllTopics();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.loadAllTopics();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
