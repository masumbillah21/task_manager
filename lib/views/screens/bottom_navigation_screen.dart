import 'package:flutter/material.dart';
import 'package:task_manager/views/screens/tasks/cancelled_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/completed_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/new_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/progress_task_list_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_app_bar.dart';

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

  int _currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentScreen],
      appBar: const TaskAppBar(),
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
            icon: Icon(Icons.alarm),
            label: 'In Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Canceled',
          ),
        ],
      ),
    );
  }
}
