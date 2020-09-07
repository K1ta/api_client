library api_client;

import 'package:api_client/src/auth.dart';
import 'package:api_client/src/host.dart';
import 'package:http/http.dart';

import 'src/endpoint.dart';
import 'src/logger.dart';

export 'src/auth.dart';
export 'src/body.dart';
export 'src/endpoint.dart';
export 'src/exceptions.dart';
export 'src/host.dart';
export 'src/logger.dart';

/// Class for holding info about http client
class ApiClient {
  /// Http client
  Client client;

  /// Api mode (for switching between hosts)
  String mode;

  /// Logger for requests
  ApiLogger logger;

  /// Default prefix for request path. It will be used if no prefix is set
  /// in endpoint.
  String defaultPrefix;

  /// Default authorization for request. It will be used if no auth is set
  /// in endpoint
  ApiAuth defaultAuth;

  /// Default authorization for request, calculating before every request. It
  /// has more priority than [defaultAuth]
  Future<ApiAuth> Function() defaultAsyncAuth;

  /// Default host for request. It will be used if no auth is set
  /// in endpoint. Host is depend on [mode]
  ApiHost defaultHost;

  /// Handlers for response, has second priority in [_handle]
  Map<int, dynamic Function(Response)> handlers;

  /// Request handler, has lowest priority in [_handle]
  Function(Response) defaultHandler;

  ApiClient(
    this.client,
    this.mode, {
    this.defaultPrefix,
    this.defaultHost,
    this.defaultAuth,
    this.defaultAsyncAuth,
    this.logger,
    this.handlers,
    this.defaultHandler,
  }) {
    logger ??= DefaultApiLogger();
  }

  /// Perform request with [client] to endpoint with info from [ep]
  Future<T> request<T>(Endpoint<T> ep) async {
    // create request
    var request = Request(
      ep.method,
      Uri.parse(ep.url(mode, defaultPrefix, defaultHost)),
    );

    // add request params
    if (ep.headers != null) {
      request.headers.addAll(ep.headers);
    }
    if (ep.auth != null) {
      request.headers['Authorization'] = ep.auth.get();
    } else if (defaultAsyncAuth != null) {
      var a = await defaultAsyncAuth();
      if (a != null) {
        request.headers['Authorization'] = a.get();
      }
    } else if (defaultAuth != null) {
      request.headers['Authorization'] = defaultAuth.get();
    }
    if (ep.body != null) {
      request.bodyBytes = ep.body.get();
      request.headers.addAll(ep.body.getHeaders());
    }

    logger?.before(ep, request);

    // send request and wait for response
    var streamedResponse = await client.send(request);
    var response = await Response.fromStream(streamedResponse);

    logger?.after(ep, response);

    return _handle(ep, response);
  }

  /// Handle response of request
  ///
  /// Order of handling: [ep.handlers] => [handlers] => [ep.defaultHandler] =>
  /// [defaultHandler]
  T _handle<T>(Endpoint<T> ep, Response r) {
    if (ep.handlers != null && ep.handlers.containsKey(r.statusCode)) {
      return ep.handlers[r.statusCode](r);
    } else if (handlers != null && handlers.containsKey(r.statusCode)) {
      return handlers[r.statusCode](r);
    } else if (ep.defaultHandler != null) {
      return ep.defaultHandler(r);
    } else if (defaultHandler != null) {
      return defaultHandler(r);
    }
    return null;
  }
}
