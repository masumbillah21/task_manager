import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/user_model.dart';

class AuthController with ChangeNotifier {
  static String? token;
  static ValueNotifier<UserModel?> user =
      ValueNotifier<UserModel?>(UserModel());

  static Future<void> saveUserInfo(
      {required String userToken, required UserModel model}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', userToken);
    await prefs.setString("user", model.toJson());
    token = userToken;
    user.value =
        UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
  }

  static Future<void> saveUserToReset({required UserModel model}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user", model.toJson());
    user.value =
        UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
  }

  static Future<void> initializeUserCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    user.value =
        UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
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
    user = ValueNotifier<UserModel?>(UserModel(
        email: '',
        password: '',
        firstName: '',
        lastName: '',
        mobile: '',
        photo: ''));
  }
}
