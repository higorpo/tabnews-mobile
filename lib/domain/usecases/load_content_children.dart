import '../entities/entities.dart';

abstract class LoadContentChildren {
  Future<List<ContentEntity>> loadContentChildren(String contentId);
}
