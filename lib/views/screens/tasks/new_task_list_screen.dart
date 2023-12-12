import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/controllers/task_count_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/screens/tasks/task_create_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/counter_container.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class NewTaskListScreen extends StatelessWidget {
  static const routeName = "/new-task";
  const NewTaskListScreen({super.key});

  Future<void> _getTakStatusCount() async {
    await Get.find<TaskCountController>().getTakStatusCount();
  }

  Future<void> _getTakList() async {
    await Get.find<TaskController>().getTakList(StatusEnum.New.name);
  }

  @override
  Widget build(BuildContext context) {
    var taskController = Get.find<TaskController>();
    if (!taskController.isNewTaskCalled) {
      _getTakStatusCount();
      _getTakList();
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 3.0,
          backgroundColor: colorGreen,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () async {
            Get.toNamed(TaskCreateScreen.routeName);
          },
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _getTakList();
            await _getTakStatusCount();
          },
          child: TaskBackgroundContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GetBuilder<TaskCountController>(builder: (status) {
                    return Visibility(
                      visible: !status.isCountLoading,
                      replacement: const Center(
                        child: LinearProgressIndicator(),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            CounterContainer(
                              taskNumber:
                                  status.getByStatus(StatusEnum.New.name),
                              taskStatus: StatusEnum.New.name,
                            ),
                            CounterContainer(
                              taskNumber:
                                  status.getByStatus(StatusEnum.Progress.name),
                              taskStatus: StatusEnum.Progress.name,
                            ),
                            CounterContainer(
                              taskNumber:
                                  status.getByStatus(StatusEnum.Completed.name),
                              taskStatus: StatusEnum.Completed.name,
                            ),
                            CounterContainer(
                              taskNumber:
                                  status.getByStatus(StatusEnum.Canceled.name),
                              taskStatus: StatusEnum.Canceled.name,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  Expanded(
                    child: GetBuilder<TaskController>(builder: (task) {
                      return task.inProgress
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : task.newTaskList!.isEmpty
                              ? const Center(
                                  child: Text(Messages.emptyTask),
                                )
                              : ListView.builder(
                                  itemCount: task.newTaskList?.length ?? 0,
                                  itemBuilder: (context, index) => TaskListCard(
                                    taskList: task.newTaskList![index],
                                    getStatusUpdate: () {
                                      _getTakList();
                                    },
                                  ),
                                );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
