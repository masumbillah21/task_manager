import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  static const routeName = "/progress-task";
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  Future<void> _getTakList() async {
    await Get.find<TaskController>().getTakList(StatusEnum.Progress);
  }

  @override
  void initState() {
    _getTakList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _getTakList();
        },
        child: TaskBackgroundContainer(
          child: GetBuilder<TaskController>(builder: (task) {
            return task.inProgress
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : task.progressTaskList!.isEmpty
                    ? const Center(
                        child: Text(Messages.emptyTask),
                      )
                    : ListView.builder(
                        itemCount: task.progressTaskList?.length ?? 0,
                        itemBuilder: (context, index) => TaskListCard(
                          taskList: task.progressTaskList![index],
                          getStatusUpdate: () {
                            _getTakList();
                          },
                        ),
                      );
          }),
        ),
      ),
    );
  }
}
