import '../../domain/domain.dart';
import '../data.dart';

class HttpLoadContent {
  final HttpClient httpClient;
  final String url;

  HttpLoadContent({required this.httpClient, required this.url});

  Future<ContentEntity?> loadContent(String contentId) async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return RemoteContentModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
