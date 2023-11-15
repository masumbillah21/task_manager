import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/utility/utility.dart';
import 'package:task_manager/views/screens/onboarding/set_password_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class PinVerificationScreen extends StatefulWidget {
  static const routeName = "./pin-verification";

  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeCTEController = TextEditingController();
  bool _inProgress = false;

  Future<void> _verifyPicCode(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _inProgress = true;
      });
      String? email = await getUserData('email');

      bool res =
          await ApiClient().verifyOTPRequest(email, _pinCodeCTEController.text);
      if (res) {
        Navigator.pushNamedAndRemoveUntil(
            context, SetPasswordScreen.routeName, (route) => false);
      }
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
                              "PIN Verification",
                              style: head1Text(colorDarkBlue),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Text(
                              "A 6 digit verification pin has been sent to your email.",
                              style: head6Text(colorLightGray),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            PinCodeTextField(
                              controller: _pinCodeCTEController,
                              keyboardType: TextInputType.number,
                              appContext: context,
                              autoDisposeControllers: false,
                              length: 6,
                              pinTheme: appOTPStyle(),
                              animationType: AnimationType.fade,
                              animationDuration:
                                  const Duration(microseconds: 300),
                              enableActiveFill: true,
                              onCompleted: (value) {
                                //_verifyPicCode(context);
                              },
                              onChanged: (value) {},
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              child: ElevatedButton(
                                style: appButtonStyle(),
                                child: successButtonChild(buttonText: "Verify"),
                                onPressed: () {
                                  _verifyPicCode(context);
                                },
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
