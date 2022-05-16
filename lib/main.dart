import 'package:flutter/material.dart';

void main() {
  runApp(const TabNews());
}

class TabNews extends StatelessWidget {
  const TabNews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tab News',
      home: Scaffold(
        body: Text('TabNews'),
      ),
    );
  }
}
