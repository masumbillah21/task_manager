import 'package:flutter/material.dart';
import 'package:task_manager/views/screens/bottom_navigation_screen.dart';
import 'package:task_manager/views/screens/onboarding/email_verification_screen.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/screens/onboarding/pin_verification_screen.dart';
import 'package:task_manager/views/screens/onboarding/registration_screen.dart';
import 'package:task_manager/views/screens/onboarding/set_password_screen.dart';
import 'package:task_manager/views/screens/onboarding/splash_screen.dart';
import 'package:task_manager/views/screens/profile/profile_update_screen.dart';
import 'package:task_manager/views/screens/tasks/cancelled_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/completed_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/new_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/progress_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/task_create_screen.dart';
import 'package:task_manager/views/style/style.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task Manager",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: colorGreen,
          foregroundColor: colorWhite,
        ),
        scaffoldBackgroundColor: colorGreen,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        RegistrationScreen.routeName: (context) => const RegistrationScreen(),
        EmailVerificationScreen.routeName: (context) =>
            const EmailVerificationScreen(),
        PinVerificationScreen.routeName: (context) =>
            const PinVerificationScreen(),
        SetPasswordScreen.routeName: (context) => const SetPasswordScreen(),
        BottomNavigationScreen.routeName: (context) =>
            const BottomNavigationScreen(),
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
