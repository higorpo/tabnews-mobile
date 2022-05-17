import '../../../../presentation/presentation.dart';
import '../../../../ui/ui.dart';

import '../../usecases/usecases.dart';

ContentPresenter makeGetxContentPresenter() {
  return GetxContentPresenter(
    loadContent: makeHttpLoadContent(),
    loadContentChildren: makeHttpLoadContentChildren(),
  );
}
