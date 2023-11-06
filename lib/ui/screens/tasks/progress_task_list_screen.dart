import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/custom_container.dart';

class ProgressTaskListScreen extends StatelessWidget {
  static const routeName = "./progress-task";
  const ProgressTaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: const CustomContainer(
        child: Center(),
      ),
    );
    ;
  }
}
