import 'package:api_client/api_client.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
    test("test", () async {
        var host = LocalApiHost();
        var e = Endpoint(
            'get',
            host,
            '/regions',
            auth: KeyAuth('secret-key'),
            defaultHandler: (r) {},
        );

        var c = Client();
        var api = ApiClient(c, ApiMode.dev, pathPrefix: '/api/v1');

        await api.request(e);
    });
}
