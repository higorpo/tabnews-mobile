import 'package:equatable/equatable.dart';

class FeedContentViewModel extends Equatable {
  final String id;
  final String slug;
  final String? title;
  final String username;
  final String createdAt;

  const FeedContentViewModel({required this.id, required this.slug, required this.title, required this.username, required this.createdAt});

  @override
  List get props => [id, slug, title, username, createdAt];
}
