import '../../../domain/domain.dart';
import '../../../data/data.dart';
import '../http/http.dart';

LoadContent makeHttpLoadContent() {
  return HttpLoadContent(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('contents/:slug'),
  );
}
