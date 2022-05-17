import '../../domain/domain.dart';
import '../data.dart';

class HttpLoadContent implements LoadContent {
  final HttpClient httpClient;
  final String url;

  HttpLoadContent({required this.httpClient, required this.url});

  @override
  Future<ContentEntity> fetch(String contentId) async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return RemoteContentModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
