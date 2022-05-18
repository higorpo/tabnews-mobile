import '../entities/entities.dart';

abstract class LoadContentChildren {
  Future<List<ContentChildEntity>> fetch(String username, String slugId);
}
