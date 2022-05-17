import 'package:flutter/material.dart';

import '../../../../ui/ui.dart';

import 'content_presenter_factory.dart';

Widget makeContentPage() {
  return ContentPage(
    presenter: makeGetxContentPresenter(),
  );
}
