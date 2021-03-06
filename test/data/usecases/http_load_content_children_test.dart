import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tab_news/data/data.dart';
import 'package:tab_news/domain/domain.dart';

import 'http_load_content_children_test.mocks.dart';

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

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl() + '/:username/:slug';
    httpClient = MockHttpClient();
    sut = HttpLoadContentChildren(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test('Should throw if url is invalid', () async {
    final sut = HttpLoadContentChildren(
      url: 'http://minhaurl.com',
      httpClient: httpClient,
    );

    final future = sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should parse username and slug on url', () async {
    const url = 'http://minhaurl.com/:username/:slug';
    final sut = HttpLoadContentChildren(
      url: url,
      httpClient: httpClient,
    );

    final slugId = faker.guid.guid();
    final username = faker.internet.userName();
    await sut.fetch(username, slugId);

    verify(httpClient.request(url: url.replaceAll(':username', username).replaceAll(':slug', slugId), method: 'get')).called(1);
  });

  test('Should call HttpClient with correct values', () async {
    sut.fetch(faker.internet.userName(), faker.guid.guid());

    verify(httpClient.request(url: anyNamed('url'), method: 'get')).called(1);
  });

  test('Should return children on 200', () async {
    final contents = await sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(
      contents,
      [
        ContentChildEntity(
          id: list[0]['id'],
          parentId: list[0]['parent_id'],
          slug: list[0]['slug'],
          body: list[0]['body'],
          createdAt: DateTime.parse(list[0]['created_at']),
          username: list[0]['username'],
          parentTitle: list[0]['parent_title'],
          parentSlug: list[0]['parent_slug'],
          parentUsername: list[0]['parent_username'],
        ),
        ContentChildEntity(
          id: list[1]['id'],
          parentId: list[1]['parent_id'],
          slug: list[1]['slug'],
          body: list[1]['body'],
          createdAt: DateTime.parse(list[1]['created_at']),
          username: list[1]['username'],
          parentTitle: list[1]['parent_title'],
          parentSlug: list[1]['parent_slug'],
          parentUsername: list[1]['parent_username'],
          children: [
            ContentChildEntity(
              id: list[1]['children'][0]['id'],
              parentId: list[1]['children'][0]['parent_id'],
              slug: list[1]['children'][0]['slug'],
              body: list[1]['children'][0]['body'],
              createdAt: DateTime.parse(list[1]['children'][0]['created_at']),
              username: list[1]['children'][0]['username'],
              parentTitle: list[1]['children'][0]['parent_title'],
              parentSlug: list[1]['children'][0]['parent_slug'],
              parentUsername: list[1]['children'][0]['parent_username'],
            ),
            ContentChildEntity(
              id: list[1]['children'][1]['id'],
              parentId: list[1]['children'][1]['parent_id'],
              slug: list[1]['children'][1]['slug'],
              body: list[1]['children'][1]['body'],
              createdAt: DateTime.parse(list[1]['children'][1]['created_at']),
              username: list[1]['children'][1]['username'],
              parentTitle: list[1]['children'][1]['parent_title'],
              parentSlug: list[1]['children'][1]['parent_slug'],
              parentUsername: list[1]['children'][1]['parent_username'],
            ),
          ],
        ),
        ContentChildEntity(
          id: list[2]['id'],
          parentId: list[2]['parent_id'],
          slug: list[2]['slug'],
          body: list[2]['body'],
          createdAt: DateTime.parse(list[2]['created_at']),
          username: list[2]['username'],
          parentTitle: list[2]['parent_title'],
          parentSlug: list[2]['parent_slug'],
          parentUsername: list[2]['parent_username'],
        ),
      ],
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData([
      {'invalid_key': 'invalid_data'}
    ]);

    final future = sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(future, throwsA(DomainError.accessDenied));
  });
}
