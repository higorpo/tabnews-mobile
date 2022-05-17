import '../../../domain/domain.dart';
import '../../../data/data.dart';
import '../http/http.dart';

LoadContents makeHttpLoadContents() {
  return HttpLoadContents(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('contents'),
  );
}
