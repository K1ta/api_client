A library for simplifying requests to API.

## Usage

A simple usage example:

```dart
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
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/K1ta/api_client/issues
