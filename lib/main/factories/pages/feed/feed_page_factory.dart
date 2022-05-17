import 'package:flutter/material.dart';

import '../../../../ui/ui.dart';

import 'feed_presenter_factory.dart';

Widget makeFeedPage() {
  return FeedPage(
    presenter: makeGetxFeedPresenter(),
  );
}
