import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownViewer extends StatelessWidget {
  final String data;

  const MarkdownViewer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      key: key,
      data: data,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      onTapLink: _handleOpenLink,
    );
  }

  void _handleOpenLink(text, href, title) {
    if (href != null) {
      final url = Uri.parse(href);
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
