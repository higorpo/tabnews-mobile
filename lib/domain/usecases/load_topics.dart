import '../entities/entities.dart';

abstract class LoadTopics {
  Future<List<TopicEntity>> loadAllTopics();
}
