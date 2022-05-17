import 'package:equatable/equatable.dart';

import 'entities.dart';

class ContentEntity extends Equatable {
  final String id;
  final String ownerId;
  final String slug;
  final String title;
  final String body;
  final ContentStatus status;
  final String? sourceUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final String username;

  const ContentEntity({
    required this.id,
    required this.ownerId,
    required this.slug,
    required this.title,
    required this.body,
    required this.status,
    this.sourceUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.username,
  });

  @override
  List<Object> get props => [id, ownerId, slug, title, body, status, createdAt, updatedAt, publishedAt, username];
}
