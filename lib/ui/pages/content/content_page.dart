import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../components/components.dart';
import 'content_presenter.dart';

class ContentPage extends StatelessWidget {
  final ContentPresenter presenter;

  const ContentPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData(Get.arguments[0], Get.arguments[1]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdo'),
      ),
      body: StreamBuilder4(
          streams: Tuple4(
            presenter.isLoadingContentStream,
            presenter.isLoadingChildrenStream,
            presenter.contentStream,
            presenter.childrenStream,
          ),
          builder: (context, snapshots) {
            if (snapshots.item1.hasData && snapshots.item1.data == true) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshots.item3.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshots.item3.error.toString(), style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(child: const Text('Recarregar'), onPressed: () => presenter.loadData(Get.arguments[0], Get.arguments[1])),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
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
            );
          }),
    );
  }
}
