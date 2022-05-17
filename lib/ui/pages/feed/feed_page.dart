import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:tab_news/ui/components/content_preview.dart';

import 'feed_content_viewmodel.dart';
import 'feed_presenter.dart';

class FeedPage extends StatelessWidget {
  final FeedPresenter presenter;

  const FeedPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('lib/ui/assets/logo.png'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => presenter.loadData(),
          ),
        ],
      ),
      body: StreamBuilder2<bool, List<FeedContentViewModel>>(
        streams: Tuple2(presenter.isLoadingStream, presenter.contentsStream),
        builder: (context, snapshots) {
          if (snapshots.item1.hasData && snapshots.item1.data == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshots.item2.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshots.item2.error.toString(), style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    ElevatedButton(child: const Text('Recarregar'), onPressed: presenter.loadData),
                  ],
                ),
              );
            }

            if (!snapshots.item2.hasData) {
              return const Center(child: Text('Não há conteúdos para mostrar...'));
            }

            return ListView.builder(
              itemCount: snapshots.item2.data?.length ?? 0,
              itemBuilder: (context, index) {
                final content = snapshots.item2.data![index];
                return ContentPreview(
                  title: content.title,
                  username: content.username,
                  createdAt: content.createdAt,
                  onTap: () => presenter.goToContent(content.slug),
                );
              },
            );
          }
        },
      ),
    );
  }
}
