import 'package:api_client/api_client.dart';
import 'package:http/http.dart';

void main() async {
  // create 'GET' endpoint
  var e = Endpoint(
    '/',
    defaultHandler: (r) => print(r.body),
  );

  // create http client and pass it to ApiClient
  var c = Client();
  // mode param is left empty because we use static host
  var api = ApiClient(c, '', defaultHost: StaticHost('google.com'));

  await api.request(e);
}
