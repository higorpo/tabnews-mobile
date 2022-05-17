import 'package:equatable/equatable.dart';

class ContentChildEntity extends Equatable {
  final String id;
  final String? parentId;
  final String slug;
  final String body;
  final DateTime createdAt;
  final String username;
  final String? parentTitle;
  final String? parentSlug;
  final String? parentUsername;
  final List<ContentChildEntity> children;

  const ContentChildEntity({
    required this.id,
    this.parentId,
    required this.slug,
    required this.body,
    required this.createdAt,
    required this.username,
    this.parentTitle,
    this.parentSlug,
    this.parentUsername,
    this.children = const [],
  });

  @override
  List<Object> get props => [id, slug, body, createdAt, username, children];
}
