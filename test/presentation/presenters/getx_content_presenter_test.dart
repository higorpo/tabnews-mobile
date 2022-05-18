import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:tab_news/domain/domain.dart';
import 'package:tab_news/presentation/presentation.dart';
import 'package:tab_news/ui/ui.dart';

import 'getx_content_presenter_test.mocks.dart';

@GenerateMocks([LoadContent, LoadContentChildren])
void main() {
  late MockLoadContent loadContent;
  late MockLoadContentChildren loadContentChildren;
  late GetxContentPresenter sut;
  late String username;
  late String contentSlug;

  ContentEntity mockValidContentData() => ContentEntity(
        id: faker.guid.guid(),
        slug: faker.randomGenerator.string(20),
        title: faker.randomGenerator.string(20),
        body: faker.randomGenerator.string(250),
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        username: faker.randomGenerator.string(10),
      );

  List<ContentChildEntity> mockValidContentChildrenData() => [
        ContentChildEntity(
          id: faker.guid.guid(),
          slug: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          username: faker.randomGenerator.string(10),
          parentId: faker.randomGenerator.string(20),
          parentSlug: faker.randomGenerator.string(20),
          parentTitle: faker.randomGenerator.string(20),
          parentUsername: faker.randomGenerator.string(10),
          children: [
            ContentChildEntity(
              id: faker.guid.guid(),
              slug: faker.randomGenerator.string(20),
              body: faker.randomGenerator.string(250),
              createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
              username: faker.randomGenerator.string(10),
              parentId: faker.randomGenerator.string(20),
              parentSlug: faker.randomGenerator.string(20),
              parentTitle: faker.randomGenerator.string(20),
              parentUsername: faker.randomGenerator.string(10),
            ),
          ],
        ),
        ContentChildEntity(
          id: faker.guid.guid(),
          slug: faker.randomGenerator.string(20),
          body: faker.randomGenerator.string(250),
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
          username: faker.randomGenerator.string(10),
          parentId: faker.randomGenerator.string(20),
          parentSlug: faker.randomGenerator.string(20),
          parentTitle: faker.randomGenerator.string(20),
          parentUsername: faker.randomGenerator.string(10),
        ),
      ];

  PostExpectation mockLoadContentCall() => when(loadContent.fetch(any, any));

  void mockLoadContent(ContentEntity data) {
    mockLoadContentCall().thenAnswer((_) async => data);
  }

  void mockLoadContentError() => mockLoadContentCall().thenThrow(DomainError.unexpected);

  PostExpectation mockLoadContentChildrenCall() => when(loadContentChildren.fetch(any, any));

  void mockLoadContentChildren(List<ContentChildEntity> data) {
    mockLoadContentChildrenCall().thenAnswer((_) async => data);
  }

  setUp(() {
    loadContent = MockLoadContent();
    loadContentChildren = MockLoadContentChildren();
    sut = GetxContentPresenter(loadContent: loadContent, loadContentChildren: loadContentChildren);
    username = faker.internet.userName();
    contentSlug = faker.guid.guid();

    mockLoadContent(mockValidContentData());
    mockLoadContentChildren(mockValidContentChildrenData());
  });

  test('Should call LoadContent on loadData', () async {
    await sut.loadData(username, contentSlug);

    verify(loadContent.fetch(username, contentSlug)).called(1);
  });

  test('Should call LoadContentChildren on loadData', () async {
    await sut.loadData(username, contentSlug);

    verify(loadContentChildren.fetch(username, contentSlug)).called(1);
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
            username: content.username,
            createdAt: '5 minutos atrás',
          ),
        ),
      ),
    );

    await sut.loadData(username, contentSlug);
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
              username: children[0].username,
              createdAt: '5 minutos atrás',
              repliesCount: '1',
            ),
            ContentViewModel(
              id: children[1].id,
              title: null,
              body: children[1].body,
              username: children[1].username,
              createdAt: '5 minutos atrás',
              repliesCount: '0',
            ),
          ],
        ),
      ),
    );

    await sut.loadData(username, contentSlug);
  });

  test('Should emit correct events on failure', () async {
    mockLoadContentError();

    expectLater(sut.isLoadingContentStream, emitsInOrder([true, false]));
    sut.contentStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

    await sut.loadData(username, contentSlug);
  });
}
