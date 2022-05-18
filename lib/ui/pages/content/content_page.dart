import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../components/components.dart';
import 'content_presenter.dart';

class ContentPage extends StatelessWidget {
  final ContentPresenter presenter;

  const ContentPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Um App para o TabNews', style: Get.textTheme.headline1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('username', style: Get.textTheme.overline),
                const SizedBox(width: 5),
                Text('•', style: Get.textTheme.overline),
                const SizedBox(width: 5),
                Text('createdAt', style: Get.textTheme.overline),
              ],
            ),
            const SizedBox(height: 16),
            const Markdown(
              data:
                  'Eu acredito na mesma coisa Marcos e vamos tomar total cuidado na parte dos TabCoins 👍\n\nO bom é que o projeto é Open Source, então tudo vai estar aberto a todos participarem e verificarem o que está sendo feito 🤝',
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 16),
              child: Text('Respostas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const ContentReply(
              username: 'higor',
              body: 'Muito honrado em poder acompanhar tudo isso e participar desde o início! 🚀\n\nIsso é um teste.',
              createdAt: '8 horas atrás',
            ),
            const ContentReply(
              username: 'higor',
              body: 'Muito honrado em poder acompanhar tudo isso e participar desde o início! 🚀\n\n--',
              createdAt: '8 horas atrás',
            ),
            const ContentReply(
              username: 'higor',
              body: 'Muito honrado em poder acompanhar tudo isso e participar desde o início! 🚀\n\n--',
              createdAt: '8 horas atrás',
            ),
          ],
        ),
      ),
    );
  }
}
