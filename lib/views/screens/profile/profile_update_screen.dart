import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/profile_image_picker.dart';
import 'package:task_manager/views/widgets/task_app_bar.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static const routeName = "./profile-update";
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  bool _inProgress = false;
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

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
                final XFile? photo = await picker.pickImage(
                  source: ImageSource.camera,
                  maxHeight: 400,
                  maxWidth: 400,
                );

                if (mounted) {
                  setState(() {
                    _imageFile = File(photo!.path);
                  });
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.browse_gallery),
              title: const Text('Upload from gallery'),
              onTap: () async {
                // Pick an image.
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxHeight: 400,
                  maxWidth: 400,
                );
                if (mounted) {
                  setState(() {
                    _imageFile = _imageFile = File(image!.path);
                    ;
                  });
                  Navigator.pop(context);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (mounted) {
      setState(() {
        _inProgress = true;
      });
    }
    UserModel formValue = UserModel(
      email: _emailTEController.text.trim(),
      firstName: _firstNameTEController.text.trim(),
      lastName: _lastNameTEController.text.trim(),
      mobile: _mobileTEController.text.trim(),
      password: _passwordTEController.text,
      photo: _imageFile,
    );
    await ApiClient().updateUserProfile(formValue);

    if (mounted) {
      setState(() {
        _inProgress = false;
      });
    }
  }

  @override
  void initState() {
    var user = AuthController.user;
    _emailTEController.text = user?.email ?? '';
    _firstNameTEController.text = user?.firstName ?? '';
    _lastNameTEController.text = user?.lastName ?? '';
    _mobileTEController.text = user?.mobile ?? '';
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
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
                  ProfileImagePicker(
                    onTab: _showPhotoDialogBox,
                    photoLink: _imageFile,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: appInputDecoration("Email Address"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: appInputDecoration("First Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'First name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: appInputDecoration("Last Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Last name is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: appInputDecoration("Mobile Number"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Mobile is required.';
                      }
                      return null;
                    },
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
                        return 'Password required.';
                      } else if (int.parse(value) < 8) {
                        return 'Password must be at least 8 characters long.';
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
                      replacement: const CircularProgressIndicator(),
                      child: ElevatedButton(
                        style: appButtonStyle(),
                        child: successButtonChild(),
                        onPressed: () {
                          updateProfile();
                        },
                      ),
                    ),
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
