import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tab_news/data/data.dart';
import 'package:tab_news/domain/domain.dart';

import 'http_load_contents_test.mocks.dart';

@GenerateMocks([HttpClient])
void main() {
  late HttpLoadContent sut;
  late MockHttpClient httpClient;
  late String url;
  late Map contentData;

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
        'parent_username': faker.randomGenerator.string(10),
      };

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(Map data) {
    contentData = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl() + '/:username/:slug';
    httpClient = MockHttpClient();
    sut = HttpLoadContent(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test('Should throw if url is invalid', () async {
    final sut = HttpLoadContent(
      url: 'http://minhaurl.com',
      httpClient: httpClient,
    );

    final future = sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should parse username and slug on url', () async {
    const url = 'http://minhaurl.com/:username/:slug';
    final sut = HttpLoadContent(
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

  test('Should return a content on 200', () async {
    final content = await sut.fetch(faker.internet.userName(), faker.guid.guid());

    expect(
      content,
      ContentEntity(
        id: contentData['id'],
        slug: contentData['slug'],
        title: contentData['title'],
        body: contentData['body'],
        createdAt: DateTime.parse(contentData['created_at']),
        username: contentData['username'],
        parentUsername: contentData['parent_username'],
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    mockHttpData({'invalid_key': 'invalid_data'});

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
