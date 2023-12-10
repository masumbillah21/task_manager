import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class CompletedTaskListScreen extends StatelessWidget {
  static const routeName = "/completed-task";
  const CompletedTaskListScreen({super.key});

  Future<void> _getTakList() async {
    await Get.find<TaskController>().getTakList(StatusEnum.Completed.name);
  }

  @override
  Widget build(BuildContext context) {
    var taskController = Get.find<TaskController>();
    if (taskController.completeTaskList == null) {
      _getTakList();
    }
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
                : task.completeTaskList!.isEmpty
                    ? const Center(
                        child: Text(Messages.emptyTask),
                      )
                    : ListView.builder(
                        itemCount: task.completeTaskList?.length ?? 0,
                        itemBuilder: (context, index) => TaskListCard(
                          taskList: task.completeTaskList![index],
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
