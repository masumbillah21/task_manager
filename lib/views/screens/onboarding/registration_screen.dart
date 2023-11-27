import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "./registration";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;
  Future<void> registration(context) async {
    if (mounted) {
      setState(() {
        _inProgress = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      UserModel formValue = UserModel(
        email: _emailTEController.text.trim(),
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        password: _passwordTEController.text,
      );

      ApiResponse response = await ApiClient().apiPostRequest(
          formValue: formValue.toJson(), url: Urls.registration);
      if (response.isSuccess) {
        successToast(Messages.registrationSuccess);
        if (mounted) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
      } else {
        errorToast(response.errorMessage);
      }
    }

    if (mounted) {
      setState(() {
        _inProgress = false;
      });
    }
  }

  @override
  void dispose() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaskBackgroundContainer(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Join With Us",
                        style: head1Text(colorDarkBlue),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTEController,
                        decoration: appInputDecoration("Email Address"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _firstNameTEController,
                        decoration: appInputDecoration("First Name"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'First name is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _lastNameTEController,
                        decoration: appInputDecoration("Last Name"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Last name is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _mobileTEController,
                        decoration: appInputDecoration("Mobile Number"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Mobile is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordTEController,
                        decoration: appInputDecoration("Password"),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password required.';
                          } else if (int.parse(value) < 8) {
                            return 'Password must be at least 8 characters long.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Visibility(
                          visible: _inProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            style: appButtonStyle(),
                            child: successButtonChild(),
                            onPressed: () {
                              registration(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have account?",
                          style: head2Text(colorGray),
                        ),
                        Text(
                          " Login",
                          style: head2Text(colorGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
