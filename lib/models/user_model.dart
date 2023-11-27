import 'dart:convert';
import 'dart:io';

class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  File? photo;
  String? password;
  String? otp;

  UserModel(
      {this.email,
      this.firstName,
      this.lastName,
      this.mobile,
      this.photo,
      this.password,
      this.otp});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'] ?? '';
    firstName = json['firstName'] ?? '';
    lastName = json['lastName'] ?? '';
    mobile = json['mobile'] ?? '';
    otp = json['OTP'] ?? '';
    // if (json['photo'] != "") {
    //   photo = showBase64Image(json['photo']);
    // }
  }

  String toJson() {
    final Map<String, dynamic> userData = <String, dynamic>{};
    userData['email'] = email;
    if (firstName != null) {
      userData['firstName'] = firstName;
    }
    if (lastName != null) {
      userData['lastName'] = lastName;
    }
    if (mobile != null) {
      userData['mobile'] = mobile;
    }
    if (photo != null) {
      userData['photo'] = base64Encode(photo!.readAsBytesSync());
    }
    if (password != null && password!.isNotEmpty) {
      userData['password'] = password;
    }
    if (otp != null && otp!.isNotEmpty) {
      userData['OTP'] = otp;
    }
    return jsonEncode(userData);
  }
}
