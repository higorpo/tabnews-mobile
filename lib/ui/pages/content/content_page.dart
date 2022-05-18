import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../components/components.dart';
import 'content_presenter.dart';
import 'content_viewmodel.dart';

class ContentPage extends StatelessWidget {
  final ContentPresenter presenter;

  const ContentPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData(Get.parameters['username']!, Get.parameters['slug']!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdo'),
      ),
      body: StreamBuilder4<bool, bool, ContentViewModel?, List<ContentViewModel>>(
          initialData: const Tuple4(true, true, null, []),
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

            if (!snapshots.item3.hasData || snapshots.item3.data == null) {
              return const Center(
                child: Text('Não há nada para mostrar!'),
              );
            }

            final content = snapshots.item3.data!;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (content.title != null) Text(content.title!, style: Get.textTheme.headline1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(content.username, style: Get.textTheme.overline),
                      const SizedBox(width: 5),
                      Text('•', style: Get.textTheme.overline),
                      const SizedBox(width: 5),
                      Text(content.createdAt, style: Get.textTheme.overline),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Markdown(
                    data: content.body,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 16),
                    child: Text('Respostas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  Builder(
                    builder: (context) {
                      if (snapshots.item2.hasData && snapshots.item2.data == true) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 18.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshots.item4.hasError) {
                        return Text(snapshots.item3.error.toString(), style: const TextStyle(fontSize: 16), textAlign: TextAlign.center);
                      }

                      if (!snapshots.item4.hasData || snapshots.item4.data!.isEmpty) {
                        return const Text('Não há respostas para mostrar!');
                      }

                      final children = snapshots.item4.data!;

                      return Column(
                        children: [
                          for (var content in children)
                            ContentReply(
                              username: content.username,
                              body: content.body,
                              createdAt: content.createdAt,
                              repliesCount: content.repliesCount ?? '0',
                            )
                        ],
                      );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}
