import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/views/screens/bottom_navigation_screen.dart';
import 'package:task_manager/views/screens/onboarding/login_screen.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLogin = false;

  Future<void> isLogin() async {
    _isLogin = await Get.find<AuthController>().checkAuthState();
    Future.delayed(
      const Duration(seconds: 3),
      () => _isLogin
          ? Get.offAllNamed(BottomNavigationScreen.routeName)
          : Get.offAllNamed(LoginScreen.routeName),
    );
  }

  @override
  void initState() {
    isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaskBackgroundContainer(
        child: Center(
          child: SvgPicture.asset(
            "assets/images/logo.svg",
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
