
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

///
class EncryptUtils{

  ///
  static String toMD5(String text) {
    Uint8List content = Utf8Encoder().convert(text);
    Digest digest = md5.convert(content);
    return digest.toString();
  }
}