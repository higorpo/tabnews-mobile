import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:get/get.dart';

import 'package:tab_news/domain/domain.dart';
import 'package:tab_news/ui/ui.dart';

import 'getx_feed_presenter_test.mocks.dart';

class GetxFeedPresenter {
  final LoadContents loadContents;

  final _isLoading = true.obs;
  final _contents = Rx<List<FeedContentViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<FeedContentViewModel>> get contentsStream => _contents.stream;

  GetxFeedPresenter({required this.loadContents});

  Future<void> loadData() async {
    _isLoading.value = true;

    try {
      final contents = await loadContents.loadContents();
      _contents.value = contents
          .map((content) => FeedContentViewModel(
                id: content.id,
                title: content.title,
                username: content.username,
                createdAt: content.createdAt.timeAgo(),
              ))
          .toList();
    } on DomainError {
      _contents.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
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
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
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
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
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

  void mockLoadContentsError() => mockLoadContentsCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadContents = MockLoadContents();
    sut = GetxFeedPresenter(loadContents: loadContents);

    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadContents on loadData', () async {
    await sut.loadData();

    verify(loadContents.loadContents()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.contentsStream.listen(expectAsync1((contents) => expect(contents, [
          FeedContentViewModel(
            id: contents[0].id,
            title: contents[0].title,
            username: contents[0].username,
            createdAt: '5 minutos atrás',
          ),
          FeedContentViewModel(
            id: contents[1].id,
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
