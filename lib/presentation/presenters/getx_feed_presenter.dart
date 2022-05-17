import 'package:get/get.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

class GetxFeedPresenter implements FeedPresenter {
  final LoadContents loadContents;

  final _isLoading = true.obs;
  final _contents = Rx<List<FeedContentViewModel>>([]);

  @override
  Stream<bool> get isLoadingStream => _isLoading.stream;

  @override
  Stream<List<FeedContentViewModel>> get contentsStream => _contents.stream;

  GetxFeedPresenter({required this.loadContents});

  @override
  Future<void> loadData() async {
    _isLoading.value = true;

    try {
      final contents = await loadContents.fetch();
      _contents.value = contents
          .map((content) => FeedContentViewModel(
                id: content.id,
                title: content.title,
                username: content.username,
                createdAt: content.createdAt.timeAgo(numericDates: false),
              ))
          .toList();
    } on DomainError {
      _contents.subject.addError(UIError.unexpected.description);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void goToContent(String id) {
    Get.toNamed('/content', arguments: id);
  }
}
