import 'dart:convert';
import 'dart:typed_data';

Uint8List showBase64Image(base64String) {
  Uint8List myImage = const Base64Decoder().convert(base64String);
  return myImage;
}

bool validateEmail(String email) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(email)) ? false : true;
}

bool validatePhoneNumber(String phoneNumber) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regex = RegExp(pattern);
  return (!regex.hasMatch(phoneNumber)) ? false : true;
}
