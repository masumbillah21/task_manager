import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/ui/screens/onboarding/login_screen.dart';
import 'package:task_manager/ui/widgets/custom_container.dart';

class NewTaskListScreen extends StatefulWidget {
  static const routeName = "./new-task";
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  Future<void> logOut(context) async {
    bool isLogout = await ApiClient().userLogout();
    if (isLogout) {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          IconButton(
            onPressed: () {
              logOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const CustomContainer(
        child: Center(),
      ),
    );
  }
}
