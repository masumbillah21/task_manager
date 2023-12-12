import 'package:get/get.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/urls.dart';

class UserController extends GetxController {
  bool _inProgress = false;

  final AuthController _authController = Get.find<AuthController>();

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
      await _authController.saveUserInfo(
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
      _authController.saveUserToReset(
          model: UserModel.fromJson({'email': email}));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyPicCode(String pin) async {
    _inProgress = true;
    update();

    String? email = AuthController().user?.email ?? '';

    ApiResponse res =
        await ApiClient().apiGetRequest(url: Urls.recoverVerifyOTP(email, pin));
    _inProgress = false;
    update();
    if (res.isSuccess) {
      _authController.saveUserToReset(
          model: UserModel.fromJson({'email': email, 'OTP': pin}));
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setPassword(String password) async {
    _inProgress = true;
    update();

    String? email = AuthController().user?.email ?? '';
    String? otp = AuthController().user?.otp ?? '';

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
      _authController.saveUserToReset(model: formValue);
      return true;
    } else {
      return false;
    }
  }
}
