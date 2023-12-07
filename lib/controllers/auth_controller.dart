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

  Future<bool> userLogin(
    String email,
    String password,
  ) async {
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

  Future<bool> userRegistration(
      {required String email,
      required String firstName,
      required String lastName,
      required String mobile,
      required String password}) async {
    _inProgress = true;
    update();

    UserModel formValue = UserModel(
      email: email,
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      password: password,
      photo: '',
    );

    ApiResponse response = await ApiClient().apiPostRequest(
      formValue: formValue.toJson(),
      url: Urls.registration,
    );
    _inProgress = false;
    update();
    if (response.isSuccess) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyUserEmail(String email) async {
    _inProgress = true;
    update();

    ApiResponse res =
        await ApiClient().apiGetRequest(url: Urls.recoverVerifyEmail(email));
    _inProgress = false;
    update();
    if (res.isSuccess) {
      saveUserToReset(model: UserModel.fromJson({'email': email}));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyPicCode(String pin) async {
    _inProgress = true;
    update();

    String? email = user?.email ?? '';

    ApiResponse res =
        await ApiClient().apiGetRequest(url: Urls.recoverVerifyOTP(email, pin));
    _inProgress = false;
    update();
    if (res.isSuccess) {
      saveUserToReset(model: UserModel.fromJson({'email': email, 'OTP': pin}));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setPassword(String password) async {
    _inProgress = true;
    update();

    String? email = user?.email ?? '';
    String? otp = user?.otp ?? '';

    UserModel formValue = UserModel(
      email: email,
      otp: otp,
      password: password,
    );

    ApiResponse res = await ApiClient().apiPostRequest(
        url: Urls.recoverResetPass, formValue: formValue.toJson());
    _inProgress = false;
    update();
    if (res.isSuccess) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfile(
      {required String email,
      required String firstName,
      required String lastName,
      required String mobile,
      String password = '',
      String photo = ''}) async {
    _inProgress = true;
    update();

    UserModel formValue = UserModel(
      email: email,
      firstName: firstName,
      lastName: lastName,
      mobile: mobile,
      password: password,
      photo: photo,
    );
    ApiResponse res = await ApiClient()
        .apiPostRequest(url: Urls.profileUpdate, formValue: formValue.toJson());

    _inProgress = false;
    update();
    if (res.isSuccess) {
      saveUserToReset(model: formValue);
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
