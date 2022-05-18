import '../../domain/domain.dart';
import '../http/http.dart';

class RemoteContentChildModel {
  final String id;
  final String ownerId;
  final String parentId;
  final String slug;
  final String body;
  final String status;
  final String? sourceUrl;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String username;
  final String? parentTitle;
  final String parentSlug;
  final String parentUsername;
  final List<RemoteContentChildModel> children;

  RemoteContentChildModel({
    required this.id,
    required this.ownerId,
    required this.parentId,
    required this.slug,
    required this.body,
    required this.status,
    required this.sourceUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.username,
    required this.parentTitle,
    required this.parentSlug,
    required this.parentUsername,
    required this.children,
  });

  factory RemoteContentChildModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'id',
      'owner_id',
      'parent_id',
      'slug',
      'body',
      'status',
      'source_url',
      'created_at',
      'updated_at',
      'published_at',
      'username',
      'parent_title',
      'parent_slug',
      'parent_username',
      'children'
    ])) {
      throw HttpError.invalidData;
    }

    final children = json['children']?.map<RemoteContentChildModel>((child) => RemoteContentChildModel.fromJson(child))?.toList();

    return RemoteContentChildModel(
      id: json['id'],
      ownerId: json['owner_id'],
      parentId: json['parent_id'],
      slug: json['slug'],
      body: json['body'],
      status: json['status'],
      sourceUrl: json['source_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      publishedAt: json['published_at'],
      username: json['username'],
      parentTitle: json['parent_title'],
      parentSlug: json['parent_slug'],
      parentUsername: json['parent_username'],
      children: children,
    );
  }

  ContentChildEntity toEntity() {
    return ContentChildEntity(
      id: id,
      parentId: parentId,
      slug: slug,
      body: body,
      createdAt: DateTime.parse(createdAt),
      username: username,
      parentTitle: parentTitle,
      parentSlug: parentSlug,
      parentUsername: parentUsername,
      children: children.map((child) => child.toEntity()).toList(),
    );
  }
}
