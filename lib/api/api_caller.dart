import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/utility/utility.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/screens/task_manager_app.dart';
import 'package:task_manager/views/style/style.dart';

class ApiClient {
  final requestHeader = {
    "Content-Type": "application/json",
    'token': AuthController.token.toString(),
  };

  Future<ApiResponse> apiPostRequest({
    required String url,
    required String formValue,
    bool isLogin = false,
  }) async {
    try {
      var uri = Uri.parse(url);
      var response =
          await http.post(uri, headers: requestHeader, body: formValue);
      var resData = jsonDecode(response.body);

      if (response.statusCode == 200 && resData['status'] == 'success') {
        return ApiResponse(
          isSuccess: true,
          jsonResponse: resData,
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        if (!isLogin) {
          backToLogin();
        }
        return ApiResponse(
          isSuccess: false,
          jsonResponse: resData,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          jsonResponse: resData,
          statusCode: response.statusCode,
        );
      }
    } catch (err) {
      return ApiResponse(isSuccess: false, errorMessage: err.toString());
    }
  }

  Future<ApiResponse> apiGetRequest({
    required String url,
  }) async {
    try {
      var uri = Uri.parse(url);
      var response = await http.get(
        uri,
        headers: requestHeader,
      );
      var resData = jsonDecode(response.body);

      if (response.statusCode == 200 && resData['status'] == 'success') {
        return ApiResponse(
          isSuccess: true,
          jsonResponse: resData,
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 401) {
        backToLogin();
        return ApiResponse(
          isSuccess: false,
          jsonResponse: resData,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          jsonResponse: resData,
          statusCode: response.statusCode,
        );
      }
    } catch (err) {
      return ApiResponse(isSuccess: false, errorMessage: err.toString());
    }
  }

  Future<bool> verifyEmailRequest(String email) async {
    var url = Uri.parse("${Urls.recoverVerifyEmail}/$email");

    try {
      var response = await http.get(url, headers: requestHeader);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("PIN Sent Success");
        await storeUserData('email', email);
        return true;
      } else {
        errorToast("Pin Sent Failed! Try again");
        return false;
      }
    } catch (_) {
      errorToast("Pin Sent Failed! Try again");
      return false;
    }
  }

  Future<bool> verifyOTPRequest(email, otp) async {
    var url = Uri.parse("${Urls.recoverVerifyOTP}/$email/$otp");

    try {
      var response = await http.get(url, headers: requestHeader);
      var resData = jsonDecode(response.body);

      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("OTP Verification Success.");
        await storeUserData('otp', otp);
        return true;
      } else {
        errorToast("OTP Verification Failed! Try again.");
        return false;
      }
    } catch (_) {
      errorToast("OTP Verification Failed! Try again.");
      return false;
    }
  }

  Future<bool> setPasswordRequest(formValue) async {
    var url = Uri.parse(Urls.recoverResetPass);
    var postBody = jsonEncode(formValue);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: postBody);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("Password Set Success");
        return true;
      } else {
        errorToast("Password Set Failed! Try again");
        return false;
      }
    } catch (_) {
      errorToast("Password Set Failed! Try again");
      return false;
    }
  }

  Future<bool> updateUserProfile(formValue) async {
    var url = Uri.parse(Urls.profileUpdate);
    String? userToken = AuthController.token;
    var postBody = jsonEncode(formValue);
    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": userToken!
    };
    try {
      var response = await http.post(
        url,
        headers: requestHeaderWithToken,
        body: postBody,
      );

      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        AuthController.saveUserInfo(userToken: userToken, model: formValue);
        successToast("Profile Update Success");
        return true;
      } else {
        errorToast("Profile Update Failed! Try again");
        return false;
      }
    } catch (_) {
      errorToast("Profile Update Failed! Try again");
      return false;
    }
  }

  Future<bool> updateTaskStatus(String id, String status) async {
    var url = Uri.parse("${Urls.updateTaskStatus}/$id/$status");
    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": AuthController.token!
    };
    try {
      var response = await http.get(url, headers: requestHeaderWithToken);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("Task Updated");
        return true;
      } else {
        errorToast("Failed to update task. Try again");
        return false;
      }
    } catch (err) {
      errorToast("Failed to update task. Try again");
      return false;
    }
  }

  Future<bool> deleteTaskList(String id) async {
    var url = Uri.parse("${Urls.deleteTask}/$id");
    String token = await getUserData('token');
    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": token
    };
    try {
      var response = await http.get(url, headers: requestHeaderWithToken);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("Task Deleted");
        return true;
      } else {
        errorToast("Failed to delete task. Try again");
        return false;
      }
    } catch (err) {
      errorToast("Failed to delete task. Try again");
      return false;
    }
  }

  Future<void> backToLogin() async {
    await AuthController.clearAuthData();
    Navigator.pushNamedAndRemoveUntil(
        TaskManagerApp.navigationKey.currentContext!,
        LoginScreen.routeName,
        (route) => false);
  }
}
