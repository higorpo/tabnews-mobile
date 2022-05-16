import '../entities/entities.dart';

abstract class LoadContents {
  Future<List<ContentEntity>> loadContents();
}
