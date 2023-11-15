import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/views/style/style.dart';
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
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  void showPhotoDialogBox() {
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
                final XFile? photo =
                    await picker.pickImage(source: ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.browse_gallery),
              title: const Text('Upload from gallery'),
              onTap: () async {
                // Pick an image.
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
              },
            )
          ],
        ),
      ),
    );
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
                  GestureDetector(
                    onTap: showPhotoDialogBox,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorWhite,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 10,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                color: colorLightGray,
                              ),
                              child: const Text(
                                "Photo",
                                style: TextStyle(color: colorWhite),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.only(left: 8),
                              child: const Text("Photo url"),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    child: ElevatedButton(
                      style: appButtonStyle(),
                      child: successButtonChild(),
                      onPressed: () {
                        // TODO: Profile Update
                      },
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
