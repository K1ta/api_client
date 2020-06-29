import 'package:api_client/api_client.dart';

/// Host for requests
/// Depend on [ApiClient.mode]
abstract class ApiHost {
  /// Return host for this [mode]. It may be used for setting
  /// different hosts for 'dev' and 'prod' types of API
  String get(String mode);
}

/// Default modes of API
class ApiMode {
  static const String dev = 'dev';
  static const String prod = 'prod';
}

/// Default hosts of API for [ApiMode] types
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
        throw InvalidApiModeException(mode);
    }
  }
}

/// Host for working with local API
class LocalApiHost implements ApiHost {
  final String port;

  LocalApiHost({this.port = '8080'});

  @override
  String get(String _) => '127.0.0.1:$port';
}

/// Host with static value, it always will return [host],
/// so [ApiClient.mode] can be left empty
class StaticHost implements ApiHost {
  final String host;

  StaticHost(this.host);

  @override
  String get(String _) => host;
}
