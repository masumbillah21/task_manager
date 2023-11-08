import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/profile/profile_update_screen.dart';
import 'package:task_manager/ui/style/style.dart';

class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstName;
  final String lastName;
  final String email;
  const TaskAppBar(
      {required this.firstName,
      required this.lastName,
      required this.email,
      super.key});
  @override
  Size get preferredSize => const Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize, // Set this height
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, ProfileUpdateScreen.routeName);
        },
        tileColor: colorGreen,
        leading: const CircleAvatar(),
        title: Text(
          "$firstName $lastName",
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          email,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
