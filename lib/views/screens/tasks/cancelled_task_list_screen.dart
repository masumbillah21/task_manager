import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  static const routeName = "/cancel-task";
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() =>
      _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  Future<void> _getTakList() async {
    await Get.find<TaskController>().getTakList(StatusEnum.Canceled);
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
                : task.cancelTaskList!.isEmpty
                    ? const Center(
                        child: Text(Messages.emptyTask),
                      )
                    : ListView.builder(
                        itemCount: task.cancelTaskList?.length ?? 0,
                        itemBuilder: (context, index) => TaskListCard(
                          taskList: task.cancelTaskList![index],
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
