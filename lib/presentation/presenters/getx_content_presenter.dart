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
  Future<void> loadData(String username, String slugId) async {
    _isLoadingContent.value = true;
    _isLoadingChildren.value = true;

    try {
      final content = await loadContent.fetch(username, slugId);
      _content.value = ContentViewModel(
        id: content.id,
        slug: content.slug,
        title: content.title,
        body: content.body,
        username: content.username,
        createdAt: content.createdAt.timeAgo(),
        parentUsername: content.parentUsername,
      );

      _isLoadingContent.value = false;

      try {
        final children = await loadContentChildren.fetch(username, slugId);
        _children.value = children
            .map((content) => ContentViewModel(
                  id: content.id,
                  slug: content.slug,
                  body: content.body,
                  username: content.username,
                  createdAt: content.createdAt.timeAgo(),
                  repliesCount: content.children.length.toString(),
                ))
            .toList();
      } on DomainError {
        _children.subject.addError(UIError.unexpected.description);
      } finally {
        _isLoadingChildren.value = false;
      }
    } on DomainError {
      _content.subject.addError(UIError.unexpected.description);
      _isLoadingContent.value = false;
      _isLoadingChildren.value = false;
    }
  }

  @override
  void goToContent(String username, String slug) {
    Get.toNamed('/content/$username/$slug');
  }
}
