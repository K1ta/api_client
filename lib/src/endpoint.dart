import 'package:api_client/api_client.dart';
import 'package:http/http.dart';

import 'auth.dart';
import 'host.dart';

/// Endpoint holds information for single endpoint
class Endpoint<T> {
  /// Http method
  final String method;

  /// Network, basically HTTP or HTTPS. Default is HTTP
  final String network;

  /// URI host. Depends on [ApiClient.mode]
  final ApiHost host;

  /// Path for URI
  final String path;

  /// Prefix for overriding [ApiClient.defaultPrefix]
  final String pathPrefix;

  /// Query parameters of request
  final Map<String, dynamic> query;

  /// Headers of request
  final Map<String, String> headers;

  /// Body of request
  final ApiBody body;

  /// Authorization type, e.g. [BasicAuth] and [KeyAuth]
  final ApiAuth auth;

  /// Handlers for response. Key is response code, value is handler
  /// This handler has first priority in [ApiClient._handle]
  final Map<int, T Function(Response)> handlers;

  /// Default handler if [handlers] and [ApiClient.defaultHandlers] has
  /// no handler for this response code
  final T Function(Response) defaultHandler;

  Endpoint(
    this.path, {
    this.method = 'GET',
    this.host,
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
      throw Exception('Path must not be started with "/"');
    }
  }

  @override
  String toString() {
    return '$method $network ${pathPrefix ?? ''} $path $query $headers';
  }

  /// Form url with params from [ApiClient]
  String url(String mode, String defaultPrefix, ApiHost defaultHost) {
    var p = pathPrefix ?? defaultPrefix ?? '';
    var h = host ?? defaultHost ?? LocalApiHost();
    return '$network://${h.get(mode)}$p$path${_query()}';
  }

  /// Helper function for forming query params
  String _query() {
    var res = '';
    if (query?.isNotEmpty ?? false) {
      res += '?';
      res += query.entries.map((e) => '${e.key}=${e.value}').join('&');
    }
    return res;
  }
}

/// Types of network to use with [ApiClient]
class ApiNetwork {
  static const String HTTP = 'http';
  static const String HTTPS = 'https';
}
