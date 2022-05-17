import '../../domain/domain.dart';

import '../data.dart';

class HttpLoadContentChildren implements LoadContentChildren {
  final String url;
  final HttpClient httpClient;

  HttpLoadContentChildren({required this.url, required this.httpClient});

  @override
  Future<List<ContentChildEntity>> fetch(String slugId) async {
    try {
      if (url.isEmpty || !url.contains(':slug')) {
        throw DomainError.unexpected;
      }

      String urlWithSlug = url.replaceAll(':slug', slugId);

      final response = await httpClient.request(url: urlWithSlug, method: 'get');
      return response.map<ContentChildEntity>((map) => RemoteContentChildModel.fromJson(map).toEntity()).toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
