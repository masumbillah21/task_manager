import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/utilities.dart';
import 'package:task_manager/views/screens/bottom_navigation_screen.dart';
import 'package:task_manager/views/screens/onboarding/email_verification_screen.dart';
import 'package:task_manager/views/screens/onboarding/registration_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      bool response = await Get.find<AuthController>().userLogin(
        _emailTEController.text.trim(),
        _passwordTEController.text,
      );
      if (response) {
        successToast(Messages.loginSuccess);

        Get.offAllNamed(BottomNavigationScreen.routeName);
      } else {
        successToast(Messages.loginFailed);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.clear();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get Started With",
                        style: head1Text(colorDarkBlue),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Text(
                        "Welcome to task manager",
                        style: head2Text(colorGray),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTEController,
                        decoration:
                            const InputDecoration(label: Text("Email Address")),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Messages.requiredEmail;
                          } else if (!validateEmail(value)) {
                            return Messages.inValidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordTEController,
                        decoration:
                            const InputDecoration(label: Text("Password")),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Messages.requiredPassword;
                          } else if (value.length < 8) {
                            return Messages.passwordLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: GetBuilder<AuthController>(
                            builder: (authController) {
                          return Visibility(
                            visible: !authController.inProgress,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              child: buttonChild(),
                              onPressed: () {
                                _login();
                              },
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(EmailVerificationScreen.routeName);
                    },
                    child: Text(
                      "Forgot password?",
                      style: head3Text(colorGray),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(RegistrationScreen.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account?",
                          style: head3Text(colorGray),
                        ),
                        Text(
                          " Sign Up",
                          style: head3Text(colorGreen),
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
