import 'package:tab_news/data/http/http.dart';
import 'package:tab_news/domain/usecases/entities/entities.dart';

class RemoteTopicModel {
  final String id;
  final String ownerId;
  final String? parentId;
  final String slug;
  final String title;
  final String body;
  final String status;
  final String? sourceUrl;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String username;
  final String? parentTitle;
  final String? parentSlug;
  final String? parentUsername;

  RemoteTopicModel({
    required this.id,
    required this.ownerId,
    required this.parentId,
    required this.slug,
    required this.title,
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
  });

  factory RemoteTopicModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'id',
      'owner_id',
      'parent_id',
      'slug',
      'title',
      'body',
      'status',
      'source_url',
      'created_at',
      'updated_at',
      'published_at',
      'username',
      'parent_title',
      'parent_slug',
      'parent_username'
    ])) {
      throw HttpError.invalidData;
    }

    return RemoteTopicModel(
      id: json['id'],
      ownerId: json['owner_id'],
      parentId: json['parent_id'],
      slug: json['slug'],
      title: json['title'],
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
    );
  }

  TopicEntity toEntity() {
    return TopicEntity(
      id: id,
      ownerId: ownerId,
      parentId: parentId,
      slug: slug,
      title: title,
      body: body,
      status: status == 'published' ? TopicStatus.published : TopicStatus.draft,
      sourceUrl: sourceUrl,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      publishedAt: DateTime.parse(publishedAt),
      username: username,
      parentTitle: parentTitle,
      parentSlug: parentSlug,
      parentUsername: parentUsername,
    );
  }
}
