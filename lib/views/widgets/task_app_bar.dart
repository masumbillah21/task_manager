import 'package:flutter/material.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/screens/profile/profile_update_screen.dart';
import 'package:task_manager/views/style/style.dart';

class TaskAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool enableProfile;
  const TaskAppBar({this.enableProfile = true, super.key});

  @override
  State<TaskAppBar> createState() => _TaskAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _TaskAppBarState extends State<TaskAppBar> {
  Future<void> _logOut(context) async {
    await AuthController.clearAuthData();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  String get fullName {
    return '${AuthController.user?.firstName ?? ''} ${AuthController.user?.lastName ?? ')'}';
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize, // Set this height
      child: SafeArea(
        child: ListTile(
          onTap: () {
            if (widget.enableProfile) {
              Navigator.pushNamed(context, ProfileUpdateScreen.routeName);
            }
          },
          leading: const CircleAvatar(
            backgroundColor: colorWhite,
            backgroundImage: AssetImage('assets/images/placeholder.png'),
          ),
          title: Text(
            fullName,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            AuthController.user?.email ?? '',
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
  }
}
