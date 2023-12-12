import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/views/screens/onboarding/set_password_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class OTPVerificationScreen extends StatefulWidget {
  static const routeName = "/pin-verification";

  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeCTEController = TextEditingController();

  Future<void> _verifyPicCode() async {
    if (_formKey.currentState!.validate()) {
      bool res = await Get.find<UserController>()
          .verifyPicCode(_pinCodeCTEController.text.trim());
      if (res) {
        successToast(Messages.otpSuccess);
        Get.offNamedUntil(SetPasswordScreen.routeName, (route) => false);
      } else {
        errorToast(Messages.otpFailed);
      }
    }
  }

  @override
  void dispose() {
    _pinCodeCTEController.dispose();
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
                        "PIN Verification",
                        style: head1Text(colorDarkBlue),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      Text(
                        "A 6 digit verification pin has been sent to your email.",
                        style: head2Text(colorGray),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PinCodeTextField(
                        controller: _pinCodeCTEController,
                        keyboardType: TextInputType.number,
                        backgroundColor: Colors.transparent,
                        appContext: context,
                        autoDisposeControllers: false,
                        length: 6,
                        pinTheme: appOTPStyle(),
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(microseconds: 300),
                        enableActiveFill: true,
                        onSubmitted: (_) {
                          _verifyPicCode();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Messages.requiredOTP;
                          } else if (value.length < 6) {
                            return Messages.otpLength;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: GetBuilder<UserController>(builder: (auth) {
                          return Visibility(
                            visible: auth.inProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              child: buttonChild(buttonText: "Verify"),
                              onPressed: () {
                                _verifyPicCode();
                              },
                            ),
                          );
                        }),
                      )
                    ],
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
