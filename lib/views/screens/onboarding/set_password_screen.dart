import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/utility/utility.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = "./set-password";
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  String _confirmPassword = '';
  final Map<String, String> _formValue = {
    "email": "",
    "OTP": "",
    "password": ""
  };

  Future<void> setPassword(context) async {
    if (_formKey.currentState!.validate()) {
      String? email = await getUserData('email');
      String? otp = await getUserData('otp');
      _formValue.update('OTP', (value) => otp);
      _formValue.update('email', (value) => email);
      _formValue.update('password', (value) => _passwordTEController.text);

      bool res = await ApiClient().setPasswordRequest(_formValue);
      if (res) {
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      }
    }
  }

  @override
  void dispose() {
    _passwordTEController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaskBackgroundContainer(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Set Password",
                  style: head1Text(colorDarkBlue),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  "Minimum length of password must be 8 characters with letter and number combination",
                  style: head6Text(colorLightGray),
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
                      return 'Confirm password required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _confirmPassword = value;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: appInputDecoration("Confirm Password"),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm password required';
                    } else if (value != _confirmPassword) {
                      return 'Password & confirm password are not same.';
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
                    child: successButtonChild(buttonText: "Set Password"),
                    onPressed: () {
                      setPassword(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
