import 'package:equatable/equatable.dart';

class ContentViewModel extends Equatable {
  final String id;
  final String slug;
  final String? title;
  final String body;
  final String username;
  final String createdAt;
  final String? repliesCount;

  const ContentViewModel({
    required this.id,
    required this.slug,
    this.title,
    required this.body,
    required this.username,
    required this.createdAt,
    this.repliesCount,
  });

  @override
  List get props => [id, title, body, username, createdAt, repliesCount];
}
