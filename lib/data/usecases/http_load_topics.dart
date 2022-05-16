import '../../domain/domain.dart';
import '../data.dart';

class HttpLoadTopics {
  final String url;
  final HttpClient httpClient;

  HttpLoadTopics({required this.url, required this.httpClient});

  Future<List<TopicEntity>> loadAllTopics() async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return response.map<TopicEntity>((map) => RemoteTopicModel.fromJson(map).toEntity()).toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
