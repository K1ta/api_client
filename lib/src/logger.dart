import 'package:http/http.dart';

import 'endpoint.dart';

/// Logger that is called before and after performing request
abstract class ApiLogger {
  void before(Endpoint ep, Request request);

  void after(Endpoint ep, Response response);
}

/// Default logger for printing basic info in stdout
class DefaultApiLogger implements ApiLogger {
  @override
  void before(Endpoint ep, Request r) {
    print('Request "${ep.method.toUpperCase()}" '
        'to ${r.url} ${ep.headers ?? ''}');
  }

  @override
  void after(Endpoint ep, Response r) {
    print('Response "${ep.method.toUpperCase()}" '
        'from ${r.request.url}: ${r.statusCode} ${r.body ?? '<empty body>'} '
        '${r.headers ?? '<no headers>'}');
  }
}
