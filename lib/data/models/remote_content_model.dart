import '../../domain/domain.dart';
import '../http/http.dart';

class RemoteContentModel {
  final String id;
  final String ownerId;
  final String slug;
  final String title;
  final String body;
  final String status;
  final String? sourceUrl;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String username;

  RemoteContentModel({
    required this.id,
    required this.ownerId,
    required this.slug,
    required this.title,
    required this.body,
    required this.status,
    required this.sourceUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.username,
  });

  factory RemoteContentModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll([
      'id',
      'owner_id',
      'slug',
      'title',
      'body',
      'status',
      'source_url',
      'created_at',
      'updated_at',
      'published_at',
      'username',
    ])) {
      throw HttpError.invalidData;
    }

    return RemoteContentModel(
      id: json['id'],
      ownerId: json['owner_id'],
      slug: json['slug'],
      title: json['title'],
      body: json['body'],
      status: json['status'],
      sourceUrl: json['source_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      publishedAt: json['published_at'],
      username: json['username'],
    );
  }

  ContentEntity toEntity() {
    return ContentEntity(
      id: id,
      ownerId: ownerId,
      slug: slug,
      title: title,
      body: body,
      status: status == 'published' ? ContentStatus.published : ContentStatus.draft,
      sourceUrl: sourceUrl,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      publishedAt: DateTime.parse(publishedAt),
      username: username,
    );
  }
}
