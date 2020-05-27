abstract class ApiHost {
  String get(String mode);
}

class ApiMode {
  static const String dev = 'dev';
  static const String prod = 'prod';
}

class DefaultApiHost implements ApiHost {
  final String devHost;
  final String prodHost;

  DefaultApiHost(this.devHost, this.prodHost);

  @override
  String get(String mode) {
    switch (mode) {
      case ApiMode.dev:
        return devHost;
      case ApiMode.prod:
        return prodHost;
      default:
        throw Exception();
    }
  }
}

class LocalApiHost implements ApiHost {
  final String port;

  LocalApiHost({this.port = '8080'});

  @override
  String get(String _) {
    return '127.0.0.1:$port';
  }
}

class StaticHost implements ApiHost {
  final String host;

  StaticHost(this.host);

  @override
  String get(String _) {
    return host;
  }
}
