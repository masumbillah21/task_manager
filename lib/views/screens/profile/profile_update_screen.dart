import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/controllers/photo_controller.dart';
import 'package:task_manager/controllers/user_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/utilities.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/profile_image_picker.dart';
import 'package:task_manager/views/widgets/task_app_bar.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static const routeName = "/profile-update";
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
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

  Future<void> _takePhoto({bool isGallery = false}) async {
    bool res =
        await Get.find<PhotoController>().takePhoto(isGallery: isGallery);

    if (res) {
      Get.back();
    }
  }

  void _showPhotoDialogBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add Photo'),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: colorRed,
              ),
            )
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                // Capture a photo.
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.browse_gallery),
              title: const Text('Upload from gallery'),
              onTap: () async {
                // Pick an image.
                _takePhoto(isGallery: true);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      bool res = await Get.find<UserController>().updateProfile(
          email: _emailTEController.text.trim(),
          firstName: _firstNameTEController.text.trim(),
          lastName: _lastNameTEController.text.trim(),
          mobile: _mobileTEController.text.trim(),
          password: _passwordTEController.text,
          photo: Get.find<PhotoController>().photoInBase64 ?? '');
      if (res) {
        successToast(Messages.profileUpdateSuccess);
      } else {
        errorToast(Messages.profileUpdateFailed);
      }
    }
  }

  @override
  void initState() {
    var user = Get.find<AuthController>().user;
    _emailTEController.text = user?.email ?? '';
    _firstNameTEController.text = user?.firstName ?? '';
    _lastNameTEController.text = user?.lastName ?? '';
    _mobileTEController.text = user?.mobile ?? '';
    Get.find<PhotoController>().photoInBase64 = user?.photo ?? '';
    super.initState();
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
      appBar: const TaskAppBar(
        enableProfile: false,
      ),
      body: TaskBackgroundContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update Profile",
                    style: head1Text(colorDarkBlue),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<PhotoController>(builder: (photo) {
                    return Container(
                      alignment: Alignment.center,
                      child: photo.photoInBase64?.isNotEmpty ?? false
                          ? profileImage(
                              imageProvider: photo.photoInBase64, radius: 60)
                          : profileImage(radius: 60),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  GetBuilder<PhotoController>(builder: (photo) {
                    return ProfileImagePicker(
                      onTab: _showPhotoDialogBox,
                      photoLink: photo.imageFile,
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTEController,
                    focusNode: _emailFocusNode,
                    decoration:
                        const InputDecoration(label: Text("Email Address")),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_firstNameFocusNode);
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
                    decoration:
                        const InputDecoration(label: Text("First Name")),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_lastNameFocusNode);
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
                    decoration: const InputDecoration(label: Text("Last Name")),
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
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
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
                    decoration: const InputDecoration(
                      label: Text("Password (Optional)"),
                    ),
                    onFieldSubmitted: (_) {
                      _updateProfile();
                    },
                    obscureText: true,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (value.length < 8) {
                          return Messages.passwordLength;
                        }
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
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                          child: buttonChild(),
                          onPressed: () {
                            _updateProfile();
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
      ),
    );
  }
}
