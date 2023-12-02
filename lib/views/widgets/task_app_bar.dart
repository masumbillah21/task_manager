import 'package:flutter/material.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/user_model.dart';
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
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
        valueListenable: AuthController.user,
        builder: (context, value, _) {
          String photo = value?.photo ?? '';
          String fullName =
              '${value?.firstName ?? ''} ${value?.lastName ?? ')'}';

          return PreferredSize(
            preferredSize: preferredSize, // Set this height
            child: SafeArea(
              child: ListTile(
                onTap: () {
                  if (enableProfile) {
                    Navigator.pushNamed(context, ProfileUpdateScreen.routeName);
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
                  value?.email ?? '',
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
              ),
            ),
          );
        });
  }
}
