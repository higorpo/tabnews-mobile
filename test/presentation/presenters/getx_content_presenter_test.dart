import 'package:faker/faker.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tab_news/ui/ui.dart';
import 'package:test/test.dart';

import 'package:tab_news/domain/domain.dart';

import 'getx_content_presenter_test.mocks.dart';

class GetxContentPresenter {
  final LoadContent loadContent;
  final LoadContentChildren loadContentChildren;

  final _isLoadingContent = true.obs;
  final _isLoadingChildren = true.obs;
  final _content = Rx<ContentViewModel?>(null);
  final _children = Rx<List<ContentViewModel>>([]);

  Stream<bool> get isLoadingContentStream => _isLoadingContent.stream;
  Stream<bool> get isLoadingChildrenStream => _isLoadingChildren.stream;
  Stream<ContentViewModel?> get contentStream => _content.stream;
  Stream<List<ContentViewModel>> get childrenStream => _children.stream;

  GetxContentPresenter({required this.loadContent, required this.loadContentChildren});

  Future<void> loadData(String contentId) async {
    _isLoadingContent.value = true;
    _isLoadingChildren.value = true;

    final content = await loadContent.fetch(contentId);
    _content.value = ContentViewModel(
      id: content.id,
      title: content.title,
      body: content.body,
    );

    final children = await loadContentChildren.fetch(contentId);
    _children.value = children
        .map((content) => ContentViewModel(
              id: content.id,
              body: content.body,
            ))
        .toList();

    _isLoadingContent.value = false;
    _isLoadingChildren.value = false;
  }
}

@GenerateMocks([LoadContent, LoadContentChildren])
void main() {
  late MockLoadContent loadContent;
  late MockLoadContentChildren loadContentChildren;
  late GetxContentPresenter sut;
  late String contentId;

  ContentEntity mockValidContentData() => ContentEntity(
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

  List<ContentChildEntity> mockValidContentChildrenData() => [
        ContentChildEntity(
          id: faker.guid.guid(),
          ownerId: faker.randomGenerator.string(50),
          slug: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          status: ContentStatus.published,
          sourceUrl: null,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          updatedAt: faker.date.dateTime(),
          publishedAt: faker.date.dateTime(),
          username: faker.randomGenerator.string(10),
          parentId: faker.randomGenerator.string(20),
          parentSlug: faker.randomGenerator.string(20),
          parentTitle: faker.randomGenerator.string(20),
          parentUsername: faker.randomGenerator.string(10),
        ),
        ContentChildEntity(
          id: faker.guid.guid(),
          ownerId: faker.randomGenerator.string(50),
          slug: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          status: ContentStatus.published,
          sourceUrl: null,
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          updatedAt: faker.date.dateTime(),
          publishedAt: faker.date.dateTime(),
          username: faker.randomGenerator.string(10),
          parentId: faker.randomGenerator.string(20),
          parentSlug: faker.randomGenerator.string(20),
          parentTitle: faker.randomGenerator.string(20),
          parentUsername: faker.randomGenerator.string(10),
        ),
      ];

  PostExpectation mockLoadContentCall() => when(loadContent.fetch(any));

  void mockLoadContent(ContentEntity data) {
    mockLoadContentCall().thenAnswer((_) async => data);
  }

  PostExpectation mockLoadContentChildrenCall() => when(loadContentChildren.fetch(any));

  void mockLoadContentChildren(List<ContentChildEntity> data) {
    mockLoadContentChildrenCall().thenAnswer((_) async => data);
  }

  setUp(() {
    loadContent = MockLoadContent();
    loadContentChildren = MockLoadContentChildren();
    sut = GetxContentPresenter(loadContent: loadContent, loadContentChildren: loadContentChildren);
    contentId = faker.guid.guid();

    mockLoadContent(mockValidContentData());
    mockLoadContentChildren(mockValidContentChildrenData());
  });

  test('Should call LoadContent on loadData', () async {
    await sut.loadData(contentId);

    verify(loadContent.fetch(contentId)).called(1);
  });

  test('Should call LoadContentChildren on loadData', () async {
    await sut.loadData(contentId);

    verify(loadContentChildren.fetch(contentId)).called(1);
  });

  test('Should emit correct events to content on success', () async {
    expectLater(sut.isLoadingContentStream, emitsInOrder([true, false]));

    sut.contentStream.listen(
      expectAsync1(
        (content) => expect(
          content!,
          ContentViewModel(
            id: content.id,
            title: content.title,
            body: content.body,
          ),
        ),
      ),
    );

    await sut.loadData(contentId);
  });

  test('Should emit correct events to children on success', () async {
    expectLater(sut.isLoadingChildrenStream, emitsInOrder([true, false]));

    sut.childrenStream.listen(
      expectAsync1(
        (children) => expect(
          children,
          [
            ContentViewModel(
              id: children[0].id,
              title: null,
              body: children[0].body,
            ),
            ContentViewModel(
              id: children[1].id,
              title: null,
              body: children[1].body,
            ),
          ],
        ),
      ),
    );

    await sut.loadData(contentId);
  });
}
