import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/utilities.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "/registration";
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

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _mobileFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _registration() async {
    if (_formKey.currentState!.validate()) {
      bool response = await Get.find<UserController>().userRegistration(
        email: _emailTEController.text.trim(),
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        password: _passwordTEController.text,
      );
      if (response) {
        successToast(Messages.registrationSuccess);
        Get.offAllNamed(LoginScreen.routeName);
      } else {
        errorToast(Messages.registrationFailed);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();

    _emailFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _mobileFocusNode.dispose();
    _passwordFocusNode.dispose();
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
                        focusNode: _emailFocusNode,
                        decoration: const InputDecoration(
                          label: Text("Email Address"),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_firstNameFocusNode);
                        },
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
                        focusNode: _firstNameFocusNode,
                        decoration: const InputDecoration(
                          label: Text("First Name"),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_lastNameFocusNode);
                        },
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
                        focusNode: _lastNameFocusNode,
                        decoration:
                            const InputDecoration(label: Text("Last Name")),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_mobileFocusNode);
                        },
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
                        focusNode: _mobileFocusNode,
                        decoration:
                            const InputDecoration(label: Text("Mobile Number")),
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
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
                        focusNode: _passwordFocusNode,
                        decoration:
                            const InputDecoration(label: Text("Password")),
                        obscureText: true,
                        onFieldSubmitted: (_) {
                          _registration();
                        },
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
                        child: GetBuilder<UserController>(builder: (auth) {
                          return Visibility(
                            visible: auth.inProgress == false,
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                              child: buttonChild(),
                              onPressed: () {
                                _registration();
                              },
                            ),
                          );
                        }),
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
