import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/task_list_card.dart';

class CompletedTaskListScreen extends StatelessWidget {
  static const routeName = "./completed-task";
  const CompletedTaskListScreen({super.key});

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
