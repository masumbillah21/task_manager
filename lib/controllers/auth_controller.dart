import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/urls.dart';

class AuthController extends GetxController {
  static String? token;
  UserModel? user;

  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<bool> userLogin(String email, String password) async {
    _inProgress = true;
    update();

    UserModel formValue = UserModel(
      email: email,
      password: password,
    );

    ApiResponse response = await ApiClient().apiPostRequest(
        formValue: formValue.toJson(), url: Urls.login, isLogin: true);
    _inProgress = false;
    update();
    if (response.isSuccess) {
      await saveUserInfo(
        userToken: response.jsonResponse['token'],
        model: UserModel.fromJson(response.jsonResponse['data']),
      );
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveUserInfo(
      {required String userToken, required UserModel model}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _filterProfilePhoto(model);
    await prefs.setString('token', userToken);
    await prefs.setString("user", model.toJson());
    token = userToken;
    user = UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
    update();
  }

  Future<void> saveUserToReset({required UserModel model}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _filterProfilePhoto(model);
    await prefs.setString("user", model.toJson());
    user = UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
    update();
  }

  Future<void> initializeUserCache() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    user = UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
  }

  Future<bool> checkAuthState() async {
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
  }

  static UserModel _filterProfilePhoto(UserModel model) {
    if (model.photo != null && model.photo!.startsWith('data:image')) {
      model.photo =
          model.photo!.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    }
    return model;
  }
}
