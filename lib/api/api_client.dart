import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/utility/utility.dart';
import 'package:task_manager/views/style/style.dart';

class ApiClient {
  final requestHeader = {"Content-Type": "application/json"};

  Future<bool> loginAndRegistration({
    required Map<String, dynamic> formValue,
    required String url,
  }) async {
    var uri = Uri.parse(url);
    var postBody = jsonEncode(formValue);

    String msg = "Something went wrong! Try again later.";

    try {
      var response =
          await http.post(uri, headers: requestHeader, body: postBody);
      var resData = jsonDecode(response.body);

      if (response.statusCode == 200 && resData['status'] == 'success') {
        if (url == Urls.login) {
          AuthController.saveUserInfo(
            userToken: resData['token'],
            model: UserModel.fromJson(resData['data']),
          );
          msg = 'Login Success';
        } else if (url == Urls.registration) {
          msg = 'Registration Success';
        }
        successToast(msg);
        return true;
      } else {
        errorToast("else");
        return false;
      }
    } catch (err) {
      errorToast("catch");
      return false;
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

  Future<bool> createTask(formValue) async {
    var url = Uri.parse(Urls.createTask);
    var postBody = jsonEncode(formValue);
    String? userToken = AuthController.token;
    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": userToken!
    };
    try {
      var response =
          await http.post(url, headers: requestHeaderWithToken, body: postBody);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("Task Created Success");
        return true;
      } else {
        errorToast("Task Failed To Create! Try again");
        return false;
      }
    } catch (_) {
      errorToast("Task Failed To Create! Try again");
      return false;
    }
  }

  Future<List> getTaskList(String status) async {
    var url = Uri.parse("${Urls.listTaskByStatus}/$status");
    String token = await getUserData('token');
    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": token
    };
    try {
      var response = await http.get(url, headers: requestHeaderWithToken);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("Task Loaded");
        return resData['data'];
      } else {
        errorToast("Failed to load task. Try again");
        return [];
      }
    } catch (err) {
      errorToast("Failed to load task. Try again");
      return [];
    }
  }

  Future<bool> updateTaskStatus(String id, String status) async {
    var url = Uri.parse("${Urls.updateTaskStatus}/$id/$status");
    String? userToken = AuthController.token;
    var requestHeaderWithToken = {
      "Content-Type": "application/json",
      "token": userToken!
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
}
