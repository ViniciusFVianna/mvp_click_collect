import 'dart:convert';

class Base64Util {
  static String encode(String text) {
    return base64Encode(utf8.encode(text));
  }

  static String decode(String encoded) {
    return utf8.decode(base64Decode(encoded));
  }
}
