import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tab_news/data/data.dart';
import 'package:tab_news/domain/domain.dart';

import 'load_contents_test.mocks.dart';

class HttpLoadContent {
  final HttpClient httpClient;
  final String url;

  HttpLoadContent({required this.httpClient, required this.url});

  Future<ContentEntity?> loadContent(String contentId) async {
    final response = await httpClient.request(url: url, method: 'get');
    return RemoteContentModel.fromJson(response).toEntity();
  }
}

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
        'parent_username': null,
      };

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method')));

  void mockHttpData(Map data) {
    contentData = data;
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

  test('Should return a content on 200', () async {
    final content = await sut.loadContent(faker.guid.guid());

    expect(
      content,
      ContentEntity(
        id: contentData['id'],
        ownerId: contentData['owner_id'],
        parentId: contentData['parent_id'],
        slug: contentData['slug'],
        title: contentData['title'],
        body: contentData['body'],
        status: ContentStatus.published,
        sourceUrl: contentData['source_url'],
        createdAt: DateTime.parse(contentData['created_at']),
        updatedAt: DateTime.parse(contentData['updated_at']),
        publishedAt: DateTime.parse(contentData['published_at']),
        username: contentData['username'],
        parentTitle: contentData['parent_title'],
        parentSlug: contentData['parent_slug'],
        parentUsername: contentData['parent_username'],
      ),
    );
  });
}