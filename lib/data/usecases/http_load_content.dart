import '../../domain/domain.dart';
import '../data.dart';

class HttpLoadContent implements LoadContent {
  final HttpClient httpClient;
  final String url;

  HttpLoadContent({required this.httpClient, required this.url});

  @override
  Future<ContentEntity> fetch(String username, String slugId) async {
    try {
      if (url.isEmpty || !url.contains(':username') || !url.contains(':slug')) {
        throw DomainError.unexpected;
      }

      String urlWithUsernameAndSlug = url.replaceAll(':username', username).replaceAll(':slug', slugId);

      final response = await httpClient.request(url: urlWithUsernameAndSlug, method: 'get');
      return RemoteContentModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
