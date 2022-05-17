import '../../domain/domain.dart';

import '../data.dart';

class HttpLoadContentChildren implements LoadContentChildren {
  final String url;
  final HttpClient httpClient;

  HttpLoadContentChildren({required this.url, required this.httpClient});

  @override
  Future<List<ContentChildEntity>> fetch(String contentId) async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return response.map<ContentChildEntity>((map) => RemoteContentChildModel.fromJson(map).toEntity()).toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
