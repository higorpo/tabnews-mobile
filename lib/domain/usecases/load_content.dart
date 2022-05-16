import '../entities/entities.dart';

abstract class LoadContent {
  Future<ContentEntity> loadContent(String contentId);
}
