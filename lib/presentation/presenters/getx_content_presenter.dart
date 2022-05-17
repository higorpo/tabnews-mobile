import 'package:get/get.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

class GetxContentPresenter implements ContentPresenter {
  final LoadContent loadContent;
  final LoadContentChildren loadContentChildren;

  final _isLoadingContent = true.obs;
  final _isLoadingChildren = true.obs;
  final _content = Rx<ContentViewModel?>(null);
  final _children = Rx<List<ContentViewModel>>([]);

  @override
  Stream<bool> get isLoadingContentStream => _isLoadingContent.stream;

  @override
  Stream<bool> get isLoadingChildrenStream => _isLoadingChildren.stream;

  @override
  Stream<ContentViewModel?> get contentStream => _content.stream;

  @override
  Stream<List<ContentViewModel>> get childrenStream => _children.stream;

  GetxContentPresenter({required this.loadContent, required this.loadContentChildren});

  @override
  Future<void> loadData(String contentId) async {
    _isLoadingContent.value = true;
    _isLoadingChildren.value = true;

    try {
      final content = await loadContent.fetch(contentId);
      _content.value = ContentViewModel(
        id: content.id,
        title: content.title,
        body: content.body,
      );

      _isLoadingContent.value = false;

      final children = await loadContentChildren.fetch(contentId);
      _children.value = children
          .map((content) => ContentViewModel(
                id: content.id,
                body: content.body,
              ))
          .toList();

      _isLoadingChildren.value = false;
    } on DomainError {
      _content.subject.addError(UIError.unexpected.description);
      _isLoadingContent.value = false;
      _isLoadingChildren.value = false;
    }
  }

  @override
  void goToContent(String contentId) {
    Get.toNamed('/content', arguments: contentId);
  }
}
