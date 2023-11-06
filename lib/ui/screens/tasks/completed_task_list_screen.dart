import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/custom_container.dart';

class CompletedTaskListScreen extends StatelessWidget {
  static const routeName = "./completed-task";
  const CompletedTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: CustomContainer(
        child: Center(),
      ),
    );
  }
}
