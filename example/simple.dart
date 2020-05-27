import 'package:api_client/api_client.dart';
import 'package:http/http.dart';

void main() async {
  var e = Endpoint(
    'GET',
    StaticHost('google.com'),
    '/',
    defaultHandler: (r) => print(r.body),
  );

  var c = Client();
  var api = ApiClient(c, '');

  await api.request(e);
}
