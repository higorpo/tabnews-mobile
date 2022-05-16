import 'entities/entities.dart';

abstract class LoadTopic {
  Future<TopicEntity> loadTopic(String topicId);
}
