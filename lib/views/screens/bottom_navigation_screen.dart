import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/bottom_navigation_controller.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/screens/tasks/cancelled_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/completed_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/new_task_list_screen.dart';
import 'package:task_manager/views/screens/tasks/progress_task_list_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_app_bar.dart';

class BottomNavigationScreen extends StatelessWidget {
  static const routeName = '/bottom-navigation';
  const BottomNavigationScreen({
    super.key,
  });

  final List<Widget> _screens = const [
    NewTaskListScreen(),
    ProgressTaskListScreen(),
    CompletedTaskListScreen(),
    CancelledTaskListScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationController>(builder: (nav) {
      return Scaffold(
        body: _screens[nav.currentScreen],
        appBar: const TaskAppBar(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: nav.currentScreen,
          selectedItemColor: colorGreen,
          unselectedItemColor: colorGray,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) {
            nav.changeScreen(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.list_alt),
              label: StatusEnum.New.name,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.alarm),
              label: StatusEnum.Progress.name,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.done),
              label: StatusEnum.Completed.name,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.cancel),
              label: StatusEnum.Canceled.name,
            ),
          ],
        ),
      );
    });
  }
}
