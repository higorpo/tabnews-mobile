import 'package:equatable/equatable.dart';

class ContentViewModel extends Equatable {
  final String id;
  final String? title;
  final String body;

  const ContentViewModel({required this.id, this.title, required this.body});

  @override
  List get props => [id, title, body];
}
