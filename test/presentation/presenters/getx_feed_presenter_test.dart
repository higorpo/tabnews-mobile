import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tab_news/domain/domain.dart';
import 'package:tab_news/presentation/presentation.dart';
import 'package:tab_news/ui/ui.dart';

import 'getx_feed_presenter_test.mocks.dart';

@GenerateMocks([LoadContents])
void main() {
  late MockLoadContents loadContents;
  late GetxFeedPresenter sut;

  List<ContentEntity> mockValidData() => [
        ContentEntity(
          id: faker.guid.guid(),
          slug: faker.randomGenerator.string(20),
          title: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          username: faker.randomGenerator.string(10),
        ),
        ContentEntity(
          id: faker.guid.guid(),
          slug: faker.randomGenerator.string(20),
          title: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          username: faker.randomGenerator.string(10),
        ),
      ];

  PostExpectation mockLoadContentsCall() => when(loadContents.fetch());

  void mockLoadContents(List<ContentEntity> data) {
    mockLoadContentsCall().thenAnswer((_) async => data);
  }

  void mockLoadContentsError() => mockLoadContentsCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadContents = MockLoadContents();
    sut = GetxFeedPresenter(loadContents: loadContents);

    mockLoadContents(mockValidData());
  });

  test('Should call LoadContents on loadData', () async {
    await sut.loadData();

    verify(loadContents.fetch()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.contentsStream.listen(expectAsync1((contents) => expect(contents, [
          FeedContentViewModel(
            id: contents[0].id,
            slug: contents[0].slug,
            title: contents[0].title,
            username: contents[0].username,
            createdAt: '5 minutos atrás',
          ),
          FeedContentViewModel(
            id: contents[1].id,
            slug: contents[1].slug,
            title: contents[1].title,
            username: contents[1].username,
            createdAt: '2 dias atrás',
          ),
        ])));

    await sut.loadData();
  });

  test('Should emit correct events on failure', () async {
    mockLoadContentsError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.contentsStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });
}
