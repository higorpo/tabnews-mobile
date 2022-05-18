import '../../../domain/domain.dart';
import '../../../data/data.dart';
import '../http/http.dart';

LoadContentChildren makeHttpLoadContentChildren() {
  return HttpLoadContentChildren(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('contents/:username/:slug/children'),
  );
}
