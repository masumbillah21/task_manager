import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class SetPasswordScreen extends StatefulWidget {
  static const routeName = "/set-password";
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  String _confirmPassword = '';
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  Future<void> _setPassword() async {
    if (_formKey.currentState!.validate()) {
      bool res = await Get.find<UserController>()
          .setPassword(_passwordTEController.text);
      if (res) {
        successToast(Messages.passwordResetSuccess);
        Get.offNamedUntil(LoginScreen.routeName, (route) => false);
      } else {
        errorToast(Messages.passwordResetFailed);
      }
    }
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
                  focusNode: _passwordFocusNode,
                  decoration: const InputDecoration(label: Text("Password")),
                  obscureText: true,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_confirmPasswordFocusNode);
                  },
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
                  focusNode: _confirmPasswordFocusNode,
                  decoration:
                      const InputDecoration(label: Text("Confirm Password")),
                  obscureText: true,
                  onFieldSubmitted: (_) {
                    _setPassword();
                  },
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
                  child: GetBuilder<UserController>(builder: (auth) {
                    return Visibility(
                      visible: auth.inProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        child: buttonChild(buttonText: "Set Password"),
                        onPressed: () {
                          _setPassword();
                        },
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
