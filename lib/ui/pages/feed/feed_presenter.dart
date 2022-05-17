import 'feed_content_viewmodel.dart';

abstract class FeedPresenter {
  Stream<bool> get isLoadingStream;
  Stream<List<FeedContentViewModel>> get contentsStream;

  Future<void> loadData();
  void goToContent(String id);
}
