import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/screens/onboarding/login_screen.dart';
import 'package:task_manager/ui/screens/tasks/new_task_list_screen.dart';
import 'package:task_manager/ui/style/style.dart';
import 'package:task_manager/utility/utility.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLogin = false;

  Future<void> isLogin() async {
    String? token = await getUserData('token');
    if (token!.isNotEmpty) {
      setState(() {
        _isLogin = true;
      });
    } else {
      setState(() {
        _isLogin = false;
      });
    }
  }

  @override
  void initState() {
    isLogin();
    Future.delayed(
      const Duration(seconds: 3),
      () => _isLogin
          ? Navigator.pushNamedAndRemoveUntil(
              context, NewTaskListScreen.routeName, (route) => false)
          : Navigator.pushNamedAndRemoveUntil(
              context, LoginScreen.routeName, (route) => false),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screenBackground(context),
          Center(
            child: SvgPicture.asset(
              "assets/images/logo.svg",
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }
}
