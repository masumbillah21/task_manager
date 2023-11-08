import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_manager/ui/style/style.dart';
import 'package:task_manager/utility/utility.dart';

class ApiClient {
  final String baseUrl = 'https://task.teamrabbil.com/api/v1';
  final requestHeader = {"Content-Type": "application/json"};

  Future<bool> loginRequest(formValue) async {
    var url = Uri.parse("$baseUrl/login");
    var postBody = jsonEncode(formValue);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: postBody);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        String photo = utf8.decode(base64Url.decode(resData['data']['photo']));
        await storeUserData('token', resData['token']);
        await storeUserData('email', resData['data']['email']);
        await storeUserData('firstName', resData['data']['firstName']);
        await storeUserData('lastName', resData['data']['lastName']);
        await storeUserData('mobile', resData['data']['mobile']);
        await storeUserData('photo', photo);
        successToast("Login Success");
        return true;
      } else {
        errorToast("Login Failed! Try again");
        return false;
      }
    } catch (err) {
      errorToast("Something went wrong! Try again leter.");
      return false;
    }
  }

  Future<bool> registrationRequest(formValue) async {
    var url = Uri.parse("$baseUrl/registration");
    var postBody = jsonEncode(formValue);
    try {
      var response =
          await http.post(url, headers: requestHeader, body: postBody);
      var resData = jsonDecode(response.body);
      if (response.statusCode == 200 && resData['status'] == 'success') {
        successToast("Registration Success");
        return true;
      } else {
        errorToast("Registration Failed! Try again");
        return false;
      }
    } catch (_) {
      errorToast("Registration Failed! Try again");
      return false;
    }
  }

  Future<bool> verifyEmailRequest(email) async {
    var url = Uri.parse("$baseUrl/RecoverVerifyEmail/$email");

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
    var url = Uri.parse("$baseUrl/RecoverVerifyOTP/$email/$otp");

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
    var url = Uri.parse("$baseUrl/RecoverResetPass");
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

  Future<bool> userLogout() async {
    try {
      await deleteData('token');
      await deleteData('email');
      await deleteData('firstName');
      await deleteData('lastName');
      await deleteData('mobile');
      await deleteData('photo');
      successToast("Logout Success");
      return true;
    } catch (_) {
      errorToast("Logout Failed");
      return false;
    }
  }
}
