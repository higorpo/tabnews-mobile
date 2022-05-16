import 'package:equatable/equatable.dart';

import 'entities.dart';

class ContentEntity extends Equatable {
  final String id;
  final String ownerId;
  final String? parentId;
  final String slug;
  final String title;
  final String body;
  final ContentStatus status;
  final String? sourceUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final String username;
  final String? parentTitle;
  final String? parentSlug;
  final String? parentUsername;

  const ContentEntity({
    required this.id,
    required this.ownerId,
    this.parentId,
    required this.slug,
    required this.title,
    required this.body,
    required this.status,
    this.sourceUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.username,
    this.parentTitle,
    this.parentSlug,
    this.parentUsername,
  });

  @override
  List<Object> get props => [id];
}
