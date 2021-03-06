import '../entities/entities.dart';

abstract class LoadContent {
  Future<ContentEntity> fetch(String username, String slugId);
}
