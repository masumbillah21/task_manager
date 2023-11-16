import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/user_model.dart';

class AuthController {
  static String? token;
  static UserModel? user;

  static Future<void> saveUserInfo(
      {required String userToken, required UserModel model}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', userToken);
    await prefs.setString("user", jsonEncode(model.toJson()));
    token = userToken;
    user = UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
  }

  static Future<void> initializeUserCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    user = UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
  }

  static Future<bool> checkAuthState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      await initializeUserCache();
      return true;
    } else {
      return false;
    }
  }

  static Future<void> clearAuthData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token = null;
    user = null;
  }
}
