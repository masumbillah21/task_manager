import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/urls.dart';
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
  bool _inProgress = false;

  Future<void> setPassword(context) async {
    if (mounted) {
      setState(() {
        _inProgress = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      String? email = AuthController.user.value?.email ?? '';
      String? otp = AuthController.user.value?.otp ?? '';

      UserModel formValue = UserModel(
        email: email,
        otp: otp,
        password: _passwordTEController.text,
      );

      ApiResponse res = await ApiClient().apiPostRequest(
          url: Urls.recoverResetPass, formValue: formValue.toJson());
      if (res.isSuccess) {
        successToast(Messages.passwordResetSuccess);
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      } else {
        errorToast(Messages.passwordResetFailed);
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
                  style: head2Text(colorGray),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: const InputDecoration(label: Text("Password")),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Messages.requiredPassword;
                    } else if (value.length < 8) {
                      return Messages.passwordLength;
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
                  decoration:
                      const InputDecoration(label: Text("Confirm Password")),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Messages.requiredConfirmPassword;
                    } else if (value != _confirmPassword) {
                      return Messages.missMatchConfirmPassword;
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
                      child: buttonChild(buttonText: "Set Password"),
                      onPressed: () {
                        setPassword(context);
                      },
                    ),
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
