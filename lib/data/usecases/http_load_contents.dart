import '../../domain/domain.dart';
import '../data.dart';

class HttpLoadContents implements LoadContents {
  final String url;
  final HttpClient httpClient;

  HttpLoadContents({required this.url, required this.httpClient});

  @override
  Future<List<ContentEntity>> loadContents() async {
    try {
      final response = await httpClient.request(url: url, method: 'get');
      return response.map<ContentEntity>((map) => RemoteContentModel.fromJson(map).toEntity()).toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}
