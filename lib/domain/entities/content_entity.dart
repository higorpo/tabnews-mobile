import 'package:equatable/equatable.dart';

class ContentEntity extends Equatable {
  final String id;
  final String slug;
  final String? title;
  final String body;
  final DateTime createdAt;
  final String username;

  const ContentEntity({
    required this.id,
    required this.slug,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.username,
  });

  @override
  List get props => [id, slug, title, body, createdAt, username];
}
