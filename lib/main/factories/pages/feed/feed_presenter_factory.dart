import '../../../../presentation/presentation.dart';
import '../../../../ui/ui.dart';

import '../../usecases/usecases.dart';

FeedPresenter makeGetxFeedPresenter() {
  return GetxFeedPresenter(
    loadContents: makeHttpLoadContents(),
  );
}
