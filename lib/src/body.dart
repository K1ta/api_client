import 'dart:convert';

abstract class ApiBody {
  List<int> get();

  Map<String, String> getHeaders();
}

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
