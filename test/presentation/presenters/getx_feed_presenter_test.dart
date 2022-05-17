import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tab_news/domain/domain.dart';

import 'getx_feed_presenter_test.mocks.dart';

class GetxFeedPresenter {
  final LoadContents loadContents;

  GetxFeedPresenter({required this.loadContents});

  Future<void> loadData() async {
    await loadContents.loadContents();
  }
}

@GenerateMocks([LoadContents])
void main() {
  late MockLoadContents loadContents;
  late GetxFeedPresenter sut;
  late List<ContentEntity> contents;

  List<ContentEntity> mockValidData() => [
        ContentEntity(
          id: faker.guid.guid(),
          ownerId: faker.randomGenerator.string(50),
          slug: faker.randomGenerator.string(20),
          title: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          status: ContentStatus.published,
          sourceUrl: null,
          createdAt: faker.date.dateTime(),
          updatedAt: faker.date.dateTime(),
          publishedAt: faker.date.dateTime(),
          username: faker.randomGenerator.string(10),
        ),
        ContentEntity(
          id: faker.guid.guid(),
          ownerId: faker.randomGenerator.string(50),
          slug: faker.randomGenerator.string(20),
          title: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          status: ContentStatus.published,
          sourceUrl: null,
          createdAt: faker.date.dateTime(),
          updatedAt: faker.date.dateTime(),
          publishedAt: faker.date.dateTime(),
          username: faker.randomGenerator.string(10),
        ),
      ];

  PostExpectation mockLoadContentsCall() => when(loadContents.loadContents());

  void mockLoadSurveys(List<ContentEntity> data) {
    contents = data;
    mockLoadContentsCall().thenAnswer((_) async => data);
  }

  setUp(() {
    loadContents = MockLoadContents();
    sut = GetxFeedPresenter(loadContents: loadContents);

    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadContents on loadData', () async {
    await sut.loadData();

    verify(loadContents.loadContents()).called(1);
  });
}
