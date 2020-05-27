import 'package:api_client/api_client.dart';
import 'package:http/http.dart';

import 'auth.dart';
import 'host.dart';

class Endpoint<T> {
  final String method;
  final String network;
  final ApiHost host;
  final String path;
  final String pathPrefix;
  final Map<String, dynamic> query;
  final Map<String, String> headers;
  final ApiBody body;
  final ApiAuth auth;
  final Map<int, T Function(Response)> handlers;
  final T Function(Response) defaultHandler;

  Endpoint(
    this.method,
    this.host,
    this.path, {
    this.pathPrefix,
    this.network = ApiNetwork.HTTP,
    this.query,
    this.headers,
    this.body,
    this.auth,
    this.handlers,
    this.defaultHandler,
  }) {
    if (!path.startsWith('/')) {
      throw Exception();
    }
  }

  @override
  String toString() {
    return super.toString();
  }

  String url(String mode, String defaultPrefix) {
    var p = pathPrefix ?? defaultPrefix ?? '';
    return '$network://${host.get(mode)}$p$path${_query()}';
  }

  String _query() {
    var res = '';
    if (query?.isNotEmpty ?? false) {
      res += '?';
      res += query.entries.map((e) => '${e.key}=${e.value}').join('&');
    }
    return res;
  }
}

class ApiNetwork {
  static const String HTTP = 'http';
  static const String HTTPS = 'https';
}
