import 'content_viewmodel.dart';

abstract class ContentPresenter {
  Stream<bool> get isLoadingContentStream;
  Stream<bool> get isLoadingChildrenStream;
  Stream<ContentViewModel> get contentStream;
  Stream<List<ContentViewModel>> get childrenStream;

  Future<void> loadData();
  void goToContent(String id);
}
