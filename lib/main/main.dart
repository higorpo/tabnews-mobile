import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'factories/factories.dart';
import '../ui/ui.dart';

void main() {
  runApp(const TabNews());
}

class TabNews extends StatelessWidget {
  const TabNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'ForDev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: makeFeedPage),
      ],
    );
  }
}
