import 'dart:convert';

/// Class for creating body bytes
abstract class ApiBody {
  /// Get body bytes
  List<int> get();

  /// Get headers associated with body
  Map<String, String> getHeaders();
}

/// Json body with 'Content-Type' header
class JsonBody implements ApiBody {
  final Map<String, dynamic> payload;

  JsonBody(this.payload);

  @override
  List<int> get() {
    return utf8.encode(jsonEncode(payload));
  }

  @override
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json;charset=utf-8',
    };
  }
}

/// Url-encoded body with 'Content-Type' header
class UrlEncodedBody implements ApiBody {
  final Map<String, String> payload;

  UrlEncodedBody(this.payload);

  @override
  List<int> get() {
    var data = payload.entries.map((e) => '${e.key}=${e.value}').join('&');
    return utf8.encode(data);
  }

  @override
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
    };
  }
}

/// Body of simple string with 'Content-Type' header
class StringBody implements ApiBody {
  final String payload;

  StringBody(this.payload);

  @override
  List<int> get() {
    return utf8.encode(payload);
  }

  @override
  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'text/plaint;charset=utf-8',
    };
  }
}
