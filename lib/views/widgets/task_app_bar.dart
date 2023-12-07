import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/screens/profile/profile_update_screen.dart';
import 'package:task_manager/views/style/style.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool enableProfile;
  const TaskAppBar({this.enableProfile = true, super.key});
  @override
  Size get preferredSize => const Size.fromHeight(70);

  Future<void> _logOut(context) async {
    await AuthController.clearAuthData();
    Get.offAllNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize, // Set this height
      child: SafeArea(
        child: GetBuilder<AuthController>(builder: (authController) {
          String photo = authController.user?.photo ?? '';
          String fullName =
              '${authController.user?.firstName ?? ''} ${authController.user?.lastName ?? ')'}';
          return ListTile(
            onTap: () {
              if (enableProfile) {
                Get.toNamed(ProfileUpdateScreen.routeName);
              }
            },
            leading: photo.isNotEmpty
                ? profileImage(imageProvider: photo)
                : profileImage(),
            title: Text(
              fullName,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              authController.user?.email ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            trailing: IconButton(
              onPressed: () {
                _logOut(context);
              },
              icon: const Icon(
                Icons.logout,
                color: colorWhite,
              ),
            ),
          );
        }),
      ),
    );
  }
}
