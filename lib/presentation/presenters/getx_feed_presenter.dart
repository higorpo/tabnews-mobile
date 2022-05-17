import 'package:get/get.dart';

import '../../domain/domain.dart';
import '../../ui/ui.dart';

class GetxFeedPresenter {
  final LoadContents loadContents;

  final _isLoading = true.obs;
  final _contents = Rx<List<FeedContentViewModel>>([]);

  Stream<bool> get isLoadingStream => _isLoading.stream;
  Stream<List<FeedContentViewModel>> get contentsStream => _contents.stream;

  GetxFeedPresenter({required this.loadContents});

  Future<void> loadData() async {
    _isLoading.value = true;

    try {
      final contents = await loadContents.loadContents();
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
}
