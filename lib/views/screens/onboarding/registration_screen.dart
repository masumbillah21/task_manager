import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/utility/utilities.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "./registration";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _inProgress = false;
  Future<void> registration(context) async {
    if (mounted) {
      setState(() {
        _inProgress = true;
      });
    }
    if (_formKey.currentState!.validate()) {
      UserModel formValue = UserModel(
        email: _emailTEController.text.trim(),
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        password: _passwordTEController.text,
        photo: '',
      );

      ApiResponse response = await ApiClient().apiPostRequest(
          formValue: formValue.toJson(), url: Urls.registration);
      if (response.isSuccess) {
        successToast(Messages.registrationSuccess);
        if (mounted) {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
      } else {
        errorToast(Messages.registrationFailed);
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
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
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
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Join With Us",
                        style: head1Text(colorDarkBlue),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _emailTEController,
                        decoration:
                            const InputDecoration(label: Text("Email Address")),
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
                        controller: _firstNameTEController,
                        decoration:
                            const InputDecoration(label: Text("First Name")),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Messages.requiredFirstName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _lastNameTEController,
                        decoration:
                            const InputDecoration(label: Text("Last Name")),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Messages.requiredLastName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _mobileTEController,
                        decoration:
                            const InputDecoration(label: Text("Mobile Number")),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Messages.requiredMobileNumber;
                          } else if (value.length < 11) {
                            return Messages.invalidMobileNumber;
                          } else if (!validatePhoneNumber(value)) {
                            return Messages.invalidMobileNumber;
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
                        child: Visibility(
                          visible: _inProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            child: buttonChild(),
                            onPressed: () {
                              registration(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
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
