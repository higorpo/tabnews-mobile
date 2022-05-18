import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentReply extends StatelessWidget {
  final String username;
  final String body;
  final String createdAt;
  final GestureTapCallback? onTap;

  const ContentReply({Key? key, required this.username, required this.body, required this.createdAt, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(username, style: Get.textTheme.overline),
                    Text(createdAt, style: Get.textTheme.overline),
                  ],
                ),
                const SizedBox(height: 8),
                Text(body, style: Get.textTheme.bodyText2),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.comment),
                        SizedBox(width: 10),
                        Text('9 respostas'),
                      ],
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
