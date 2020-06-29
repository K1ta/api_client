import 'package:api_client/api_client.dart';

// Post a simple string
Endpoint postString(String data) => Endpoint(
      '/path/to/resource',
      method: 'POST',
      host: StaticHost('example.com'),
      body: StringBody(data),
      handlers: {
        201: (r) {},
        404: (_) => throw Exception('Not authorized'),
      },
      defaultHandler: (_) => throw Exception('Unknown code'),
    );

// Post json data with some custom header
Endpoint postJson(Map<String, dynamic> json, String myHeader) => Endpoint(
      '/path/to/resource',
      method: 'POST',
      host: StaticHost('example.com'),
      body: JsonBody(json),
      headers: {
        'MyHeader': myHeader,
      },
      network: ApiNetwork.HTTPS,
      handlers: {
        200: (r) => r.body,
        404: (_) => throw Exception('Not authorized'),
      },
      defaultHandler: (_) => throw Exception('Unknown code'),
    );

// Get something with basic auth
Endpoint getSomethingSecured(String login, String password) => Endpoint(
      '/secured/path/to/resource',
      host: StaticHost('example.com'),
      auth: BasicAuth(login, password),
      handlers: {
        200: (r) => r.body,
      },
    );
