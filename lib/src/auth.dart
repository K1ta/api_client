import 'dart:convert';

/// Class for creating authorization header value
abstract class ApiAuth {
  String get();
}

/// Implementation on basic auth with email and password
class BasicAuth implements ApiAuth {
  final String login;
  final String password;

  BasicAuth(this.login, this.password);

  @override
  String get() {
    var encoded = base64Encode(latin1.encode('$login:$password'));
    return 'Basic $encoded';
  }
}

/// Implementation of key auth with Bearer token
class KeyAuth implements ApiAuth {
  final String key;

  KeyAuth(this.key);

  @override
  String get() {
    return 'Bearer $key';
  }
}
