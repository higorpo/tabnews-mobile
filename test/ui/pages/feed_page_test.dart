import 'dart:async';

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

  tearDown(() {
    closeStreams();
  });

  testWidgets('Should call LoadSurveys on page load', (tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });
}
