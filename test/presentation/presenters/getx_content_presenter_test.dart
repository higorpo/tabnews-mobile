import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tab_news/domain/domain.dart';

import 'getx_content_presenter_test.mocks.dart';

class GetxContentPresenter {
  final LoadContent loadContent;

  GetxContentPresenter({required this.loadContent});

  Future<void> loadData(String contentId) async {
    await loadContent.fetch(contentId);
  }
}

@GenerateMocks([LoadContent])
void main() {
  late MockLoadContent loadContent;
  late GetxContentPresenter sut;
  late String contentId;

  ContentEntity mockValidData() => ContentEntity(
        id: faker.guid.guid(),
        ownerId: faker.randomGenerator.string(50),
        slug: faker.randomGenerator.string(20),
        title: faker.randomGenerator.string(20),
        body: faker.randomGenerator.string(250),
        status: ContentStatus.published,
        sourceUrl: null,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        updatedAt: faker.date.dateTime(),
        publishedAt: faker.date.dateTime(),
        username: faker.randomGenerator.string(10),
      );

  PostExpectation mockLoadContentsCall() => when(loadContent.fetch(any));

  void mockLoadContent(ContentEntity data) {
    mockLoadContentsCall().thenAnswer((_) async => data);
  }

  setUp(() {
    loadContent = MockLoadContent();
    sut = GetxContentPresenter(loadContent: loadContent);
    contentId = faker.guid.guid();

    mockLoadContent(mockValidData());
  });

  test('Should call LoadContent on loadData', () async {
    await sut.loadData(contentId);

    verify(loadContent.fetch(contentId)).called(1);
  });
}
