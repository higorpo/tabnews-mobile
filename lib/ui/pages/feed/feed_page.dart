import 'package:flutter/material.dart';

import 'feed_presenter.dart';

class FeedPage extends StatelessWidget {
  final FeedPresenter presenter;

  const FeedPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('lib/ui/assets/logo.png'),
      ),
      body: Container(),
    );
  }
}
