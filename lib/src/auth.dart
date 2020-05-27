import 'dart:convert';

abstract class ApiAuth {
  String get();
}

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

class KeyAuth implements ApiAuth {
  final String key;

  KeyAuth(this.key);

  @override
  String get() {
    return 'Bearer $key';
  }
}
