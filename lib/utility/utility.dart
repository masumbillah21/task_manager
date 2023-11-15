import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserData(key, email) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, email);
}

Future<String> getUserData(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key) ?? '';
}

showBase64Image(image) {
  UriData? data = Uri.parse(image).data;
  Uint8List myImage = data!.contentAsBytes();
  return myImage;
}
