import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/screens/onboarding/set_password_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class OTPVerificationScreen extends StatefulWidget {
  static const routeName = "./pin-verification";

  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeCTEController = TextEditingController();
  bool _inProgress = false;

  Future<void> _verifyPicCode(context) async {
    if (mounted) {
      setState(() {
        _inProgress = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      String? email = AuthController.user.value?.email ?? '';

      ApiResponse res = await ApiClient().apiGetRequest(
          url: Urls.recoverVerifyOTP(email, _pinCodeCTEController.text.trim()));
      if (res.isSuccess) {
        AuthController.saveUserToReset(
            model: UserModel.fromJson(
                {'email': email, 'OTP': _pinCodeCTEController.text.trim()}));
        successToast(Messages.otpSuccess);
        Navigator.pushNamedAndRemoveUntil(
            context, SetPasswordScreen.routeName, (route) => false);
      } else {
        errorToast(Messages.otpFailed);
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
    _pinCodeCTEController.clear();
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
                        child: Visibility(
                          visible: _inProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            child: buttonChild(buttonText: "Verify"),
                            onPressed: () {
                              _verifyPicCode(context);
                            },
                          ),
                        ),
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
