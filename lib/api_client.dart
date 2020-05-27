library api_client;

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
  Client client;
  String mode;

  String pathPrefix;
  ApiLogger logger;

  Map<int, Function(Response)> handlers;

  Function(Response) defaultHandler;

  ApiClient(
    this.client,
    this.mode, {
    this.pathPrefix,
    this.logger,
    this.handlers,
  }) {
    logger ??= DefaultApiLogger();
  }

  Future<T> request<T>(Endpoint<T> ep) async {
    var request = Request(ep.method, Uri.parse(ep.url(mode, pathPrefix)));
    if (ep.headers != null) {
      request.headers.addAll(ep.headers);
    }
    if (ep.auth != null) {
      request.headers['Authorization'] = ep.auth.get();
    }
    if (ep.body != null) {
      request.bodyBytes = ep.body.get();
      request.headers.addAll(ep.body.getHeaders());
    }
    logger.before(ep, request);
    var streamedResponse = await client.send(request);
    var response = await Response.fromStream(streamedResponse);
    logger.after(ep, response);
    return _handle(ep, response);
  }

  T _handle<T>(Endpoint<T> ep, Response r) {
    if (ep?.handlers?.containsKey(r.statusCode) ?? false) {
      return ep.handlers[r.statusCode](r);
    } else if (handlers?.containsKey(r.statusCode) ?? false) {
      return handlers[r.statusCode](r);
    } else if (ep.defaultHandler != null) {
      return ep.defaultHandler(r);
    } else if (defaultHandler != null) {
      return defaultHandler(r);
    }
    return null;
  }
}
