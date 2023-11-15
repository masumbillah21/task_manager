class UserModel {
  String? email;
  String? firstName;
  String? lastName;
  String? mobile;
  String? photo;

  UserModel(
      {this.email, this.firstName, this.lastName, this.mobile, this.photo});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> userData = <String, dynamic>{};
    userData['email'] = email;
    userData['firstName'] = firstName;
    userData['lastName'] = lastName;
    userData['mobile'] = mobile;
    userData['photo'] = photo;
    return userData;
  }
}
