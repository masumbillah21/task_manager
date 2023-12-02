import 'dart:convert';
import 'dart:typed_data';

Uint8List showBase64Image(base64String) {
  Uint8List myImage = const Base64Decoder().convert(base64String);
  return myImage;
}
