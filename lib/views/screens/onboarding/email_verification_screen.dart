import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/utilities.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/screens/onboarding/otp_verification_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const routeName = "/email-verification";
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();

  Future<void> _verifyEmail() async {
    if (_formKey.currentState!.validate()) {
      bool res = await Get.find<AuthController>()
          .verifyUserEmail(_emailTEController.text.trim());
      if (res) {
        successToast(Messages.emailVerificationSuccess);
        Get.toNamed(OTPVerificationScreen.routeName);
      } else {
        errorToast(Messages.emailVerificationFailed);
      }
    }
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
                        "Your Email Address",
                        style: head1Text(colorDarkBlue),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Text(
                        "A 6 digit verification pin will send to your email address",
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
                      SizedBox(
                        child: GetBuilder<AuthController>(builder: (auth) {
                          return Visibility(
                            visible: auth.inProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              child: buttonChild(buttonText: "Next"),
                              onPressed: () {
                                _verifyEmail();
                              },
                            ),
                          );
                        }),
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
                      Get.toNamed(LoginScreen.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have account?",
                          style: head3Text(colorGray),
                        ),
                        Text(
                          " Login",
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
