import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/task_list_card.dart';

class ProgressTaskListScreen extends StatelessWidget {
  static const routeName = "./progress-task";
  const ProgressTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 9,
        itemBuilder: (context, index) => const TaskListCard(),
      ),
    );
  }
}
