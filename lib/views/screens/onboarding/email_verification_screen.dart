import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/screens/onboarding/pin_verification_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const routeName = "./email-verification";
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();

  bool _inProgress = false;

  Future<void> verifyEmail(context) async {
    setState(() {
      _inProgress = true;
    });
    if (_formKey.currentState!.validate()) {
      bool res = await ApiClient().verifyEmailRequest(_emailTEController.text);
      if (res) {
        Navigator.pushReplacementNamed(
            context, PinVerificationScreen.routeName);
      }
    }

    setState(() {
      _inProgress = false;
    });
  }

  @override
  void dispose() {
    _emailTEController.clear();
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
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Your Email Address",
                              style: head1Text(colorDarkBlue),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              "A 6 digit verification pin will send to your email address",
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
                                  return 'Email is required';
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
                                child: successButtonChild(buttonText: "Next"),
                                onPressed: () {
                                  verifyEmail(context);
                                },
                              ),
                            ),
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
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have account?",
                                style: head6Text(colorLightGray),
                              ),
                              Text(
                                " Login",
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
