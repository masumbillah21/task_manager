import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/controllers/auth_controller.dart';
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
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

  String _photoInBase64 = '';
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  Future<void> _takePhoto({bool isGallery = false}) async {
    final XFile? photo;
    if (isGallery) {
      photo = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
      );
    } else {
      photo = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 400,
        maxWidth: 400,
      );
    }

    if (photo != null) {
      List<int> imageBytes = await photo.readAsBytes();

      if (mounted) {
        Navigator.pop(context);
        setState(() {
          _photoInBase64 = base64Encode(imageBytes);
          _imageFile = photo;
        });
      }
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
      bool res = await Get.find<AuthController>().updateProfile(
          email: _emailTEController.text.trim(),
          firstName: _firstNameTEController.text.trim(),
          lastName: _lastNameTEController.text.trim(),
          mobile: _mobileTEController.text.trim(),
          password: _passwordTEController.text,
          photo: _photoInBase64);
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
    _photoInBase64 = user?.photo ?? '';
    super.initState();
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
                  Container(
                    alignment: Alignment.center,
                    child: _photoInBase64.isNotEmpty
                        ? profileImage(
                            imageProvider: _photoInBase64, radius: 60)
                        : profileImage(radius: 60),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ProfileImagePicker(
                    onTab: _showPhotoDialogBox,
                    photoLink: _imageFile,
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
                    decoration: const InputDecoration(label: Text("Last Name")),
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
                    decoration: const InputDecoration(
                      label: Text("Password (Optional)"),
                    ),
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
                    child: GetBuilder<AuthController>(builder: (auth) {
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
