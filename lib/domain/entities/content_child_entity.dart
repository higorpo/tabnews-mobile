import 'package:equatable/equatable.dart';

import 'entities.dart';

class ContentChildEntity extends Equatable {
  final String id;
  final String ownerId;
  final String? parentId;
  final String slug;
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
  final List<ContentChildEntity> children;

  const ContentChildEntity({
    required this.id,
    required this.ownerId,
    this.parentId,
    required this.slug,
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
    this.children = const [],
  });

  @override
  List<Object> get props => [id, ownerId, slug, body, status, createdAt, updatedAt, publishedAt, username, children];
}
