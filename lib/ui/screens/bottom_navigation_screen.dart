import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/tasks/cancelled_task_list_screen.dart';
import 'package:task_manager/ui/screens/tasks/completed_task_list_screen.dart';
import 'package:task_manager/ui/screens/tasks/new_task_list_screen.dart';
import 'package:task_manager/ui/screens/tasks/progress_task_list_screen.dart';
import 'package:task_manager/ui/style/style.dart';
import 'package:task_manager/ui/widgets/task_app_bar.dart';
import 'package:task_manager/utility/utility.dart';

class BottomNavigationScreen extends StatefulWidget {
  static const routeName = './bottom-navigation';
  const BottomNavigationScreen({
    super.key,
  });

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  final List<Widget> _screens = const [
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen()
  ];

  String _photo = '';
  String _firstName = '';
  String _lastName = '';
  String _email = '';

  int _currentScreen = 0;

  Future<void> _getUserDataFromSpr() async {
    String photo = await getUserData('photo');
    String firstName = await getUserData('firstName');
    String lastName = await getUserData('lastName');
    String email = await getUserData('email');

    setState(() {
      _photo = photo;
      _firstName = firstName;
      _lastName = lastName;
      _email = email;
    });
  }

  @override
  void initState() {
    _getUserDataFromSpr();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[_currentScreen],
        appBar: TaskAppBar(
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentScreen,
          selectedItemColor: colorGreen,
          unselectedItemColor: colorLightGray,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            _currentScreen = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'In Progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Cancelled',
            ),
          ],
        ),
      ),
    );
  }
}
