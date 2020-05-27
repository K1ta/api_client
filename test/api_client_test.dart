import 'package:api_client/api_client.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  test("test", () async {
    var host = LocalApiHost();
    var e = Endpoint(
      '/regions',
      defaultHandler: (r) {},
    );

    var c = Client();
    var api = ApiClient(
      c,
      ApiMode.dev,
      defaultPrefix: '/api/v1',
      defaultHost: host,
      defaultAuth: KeyAuth('secret-key'),
    );

    await api.request(e);
  });
}
