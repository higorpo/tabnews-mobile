import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentPreview extends StatelessWidget {
  final String title;
  final String username;
  final String createdAt;
  final GestureTapCallback? onTap;

  const ContentPreview({Key? key, required this.title, required this.username, required this.createdAt, this.onTap}) : super(key: key);

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
                Text(title, style: Get.textTheme.headline3),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(username, style: Get.textTheme.overline),
                    Text(createdAt, style: Get.textTheme.overline),
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
