import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeUserData(key, email) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, email);
}

Future<String?> getUserData(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool?> deleteData(key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.remove(key);
}
