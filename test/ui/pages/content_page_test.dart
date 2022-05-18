import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tab_news/ui/ui.dart';

import 'content_page_test.mocks.dart';

@GenerateMocks([ContentPresenter])
void main() {
  late MockContentPresenter presenter;

  late StreamController<bool> isLoadingContentController;
  late StreamController<bool> isLoadingChildrenController;
  late StreamController<ContentViewModel?> contentController;
  late StreamController<List<ContentViewModel>> childrenController;

  late String username;
  late String slug;

  void initStreams() {
    isLoadingContentController = StreamController<bool>();
    isLoadingChildrenController = StreamController<bool>();
    contentController = StreamController<ContentViewModel?>();
    childrenController = StreamController<List<ContentViewModel>>();
  }

  void mockStreams() {
    when(presenter.isLoadingContentStream).thenAnswer((_) => isLoadingContentController.stream);
    when(presenter.isLoadingChildrenStream).thenAnswer((_) => isLoadingChildrenController.stream);
    when(presenter.contentStream).thenAnswer((_) => contentController.stream);
    when(presenter.childrenStream).thenAnswer((_) => childrenController.stream);
  }

  void closeStreams() {
    isLoadingContentController.close();
    isLoadingChildrenController.close();
    contentController.close();
    childrenController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockContentPresenter();

    initStreams();
    mockStreams();

    final contentPage = GetMaterialApp(
      initialRoute: '/content/$username/$slug',
      getPages: [
        GetPage(name: '/content/:username/:slug', page: () => ContentPage(presenter: presenter), arguments: [username, slug]),
        GetPage(name: '/any_page', page: () => Container()),
      ],
    );

    await tester.pumpWidget(contentPage);
  }

  setUp(() {
    username = faker.internet.userName();
    slug = faker.internet.domainWord();
  });

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call loadData on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadData(any, any)).called(1);
  });

  testWidgets('Should handle loading correctly for content', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingContentController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingContentController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingContentController.add(true);
    await tester.pump();

    isLoadingContentController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should handle loading correctly for children', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingContentController.add(false);
    contentController.add(const ContentViewModel(id: '1', title: 'title', body: 'body', username: 'username', createdAt: 'date'));

    isLoadingChildrenController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingChildrenController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingChildrenController.add(true);
    await tester.pump();

    isLoadingChildrenController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should not show replies if content loading is true', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingContentController.add(true);

    await tester.pump();

    expect(find.byKey(loadingChildrenKey), findsNothing);
    expect(find.text('Respostas'), findsNothing);
  });
}
