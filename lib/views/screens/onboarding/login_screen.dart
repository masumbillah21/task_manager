import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/screens/bottom_navigation_screen.dart';
import 'package:task_manager/views/screens/onboarding/email_verification_screen.dart';
import 'package:task_manager/views/screens/onboarding/registration_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = './login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;

  Future<void> login(context) async {
    setState(() {
      _inProgress = true;
    });
    if (_formKey.currentState!.validate()) {
      UserModel formValue = UserModel(
        email: _emailTEController.text.trim(),
        password: _passwordTEController.text,
      );

      bool res = await ApiClient()
          .loginAndRegistration(formValue: formValue.toJson(), url: Urls.login);
      if (res) {
        Navigator.pushNamedAndRemoveUntil(
            context, BottomNavigationScreen.routeName, (route) => false);
      }
    }

    setState(() {
      _inProgress = false;
    });
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
          child: _inProgress
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
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
                              style: head6Text(colorLightGray),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailTEController,
                              decoration: appInputDecoration("Email Address"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email required.';
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
                              child: ElevatedButton(
                                style: appButtonStyle(),
                                child: successButtonChild(),
                                onPressed: () {
                                  login(context);
                                },
                              ),
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
                            Navigator.pushNamed(
                                context, EmailVerificationScreen.routeName);
                          },
                          child: Text(
                            "Forgot password?",
                            style: head6Text(colorLightGray),
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
                            Navigator.pushNamed(
                                context, RegistrationScreen.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have account?",
                                style: head6Text(colorLightGray),
                              ),
                              Text(
                                " Sign Up",
                                style: head6Text(colorGreen),
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
