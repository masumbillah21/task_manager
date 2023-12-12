import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  int _currentScreen = 0;
  int get currentScreen => _currentScreen;
  void changeScreen(int index) {
    _currentScreen = index;
    update();
  }
}