import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/onboarding/email_verification_screen.dart';
import 'package:task_manager/ui/screens/onboarding/login_screen.dart';
import 'package:task_manager/ui/screens/onboarding/pin_verification_screen.dart';
import 'package:task_manager/ui/screens/onboarding/registration_screen.dart';
import 'package:task_manager/ui/screens/onboarding/set_password_screen.dart';
import 'package:task_manager/ui/screens/onboarding/splash_screen.dart';
import 'package:task_manager/ui/screens/profile/profile_update_screen.dart';
import 'package:task_manager/ui/screens/tasks/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screens/tasks/completed_task_list_screen.dart';
import 'package:task_manager/ui/screens/tasks/new_task_list_screen.dart';
import 'package:task_manager/ui/screens/tasks/progress_task_list_screen.dart';
import 'package:task_manager/ui/screens/tasks/task_create_screen.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task Manager",
      initialRoute: PinVerificationScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegistrationScreen.routeName: (context) => RegistrationScreen(),
        EmailVerificationScreen.routeName: (context) =>
            EmailVerificationScreen(),
        PinVerificationScreen.routeName: (context) => PinVerificationScreen(),
        SetPasswordScreen.routeName: (context) => SetPasswordScreen(),
        NewTaskListScreen.routeName: (context) => const NewTaskListScreen(),
        ProgressTaskListScreen.routeName: (context) =>
            const ProgressTaskListScreen(),
        CompletedTaskListScreen.routeName: (context) =>
            const CompletedTaskListScreen(),
        CancelledTaskListScreen.routeName: (context) =>
            const CancelledTaskListScreen(),
        TaskCreateScreen.routeName: (context) => const TaskCreateScreen(),
        ProfileUpdateScreen.routeName: (context) => const ProfileUpdateScreen(),
      },
    );
  }
}
