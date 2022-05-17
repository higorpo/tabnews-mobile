import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:tab_news/ui/ui.dart';

import 'feed_page_test.mocks.dart';

@GenerateMocks([FeedPresenter])
void main() {
  late MockFeedPresenter presenter;
  late StreamController<bool> isLoadingController;
  late StreamController<List<FeedContentViewModel>> contentsController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    contentsController = StreamController<List<FeedContentViewModel>>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream).thenAnswer((_) => isLoadingController.stream);
    when(presenter.contentsStream).thenAnswer((_) => contentsController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    contentsController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = MockFeedPresenter();

    initStreams();
    mockStreams();

    final surveysPage = GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => FeedPage(presenter: presenter)),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  List<FeedContentViewModel> makeContents() => [
        const FeedContentViewModel(id: '1', title: 'Title 1', username: 'Username 1', createdAt: 'Date 1'),
        const FeedContentViewModel(id: '2', title: 'Title 2', username: 'Username 2', createdAt: 'Date 2'),
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveys on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('Should present refresh button on app bar', (tester) async {
    await loadPage(tester);

    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('Should call LoadContents when refresh button is pressed', (tester) async {
    await loadPage(tester);

    final button = find.byType(IconButton);
    await tester.tap(button);

    verify(presenter.loadData()).called(2);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();

    isLoadingController.add(false);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should present error if contentsStream fails', (WidgetTester tester) async {
    await loadPage(tester);

    contentsController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Title 1'), findsNothing);
  });

  testWidgets('Should present list if contentsStream succeeds', (WidgetTester tester) async {
    await loadPage(tester);

    contentsController.add(makeContents());
    await tester.pump();

    expect(find.text('Algo errado aconteceu. Tente novamente em breve.'), findsNothing);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Title 1'), findsWidgets);
    expect(find.text('Title 2'), findsWidgets);
    expect(find.text('Username 1'), findsWidgets);
    expect(find.text('Username 2'), findsWidgets);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('Should call LoadContents on reload button', (WidgetTester tester) async {
    await loadPage(tester);

    contentsController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });
}
