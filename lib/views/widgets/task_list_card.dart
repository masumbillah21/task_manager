import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/status_change_controller.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/controllers/task_count_controller.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/style/style.dart';

class TaskListCard extends StatelessWidget {
  final TaskModel taskList;
  final VoidCallback getStatusUpdate;

  const TaskListCard({
    required this.taskList,
    required this.getStatusUpdate,
    super.key,
  });

  Future<void> _getTakStatusCount() async {
    await Get.find<TaskCountController>().getTakStatusCount();
  }

  Future<void> _updateTaskStatus(String status) async {
    bool res = await Get.find<TaskController>()
        .updateTaskStatus(taskId: taskList.id!, status: status);
    if (res) {
      getStatusUpdate();
      await Get.find<TaskController>().getTakList(status);
      await _getTakStatusCount();
      successToast(Messages.taskStatusSuccess);
      Get.back();
    } else {
      errorToast(Messages.taskStatusFailed);
    }
  }

  Future<void> _showUpdateModal(context, String id) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 400,
        child: Column(
          children: [
            Text(
              "Update Task Status",
              style: head1Text(colorGreen),
            ),
            const Divider(
              height: 20,
              color: colorGreen,
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    value: taskList.status,
                    isExpanded: true,
                    decoration:
                        const InputDecoration(label: Text("Task Status")),
                    items: StatusEnum.values
                        .map<DropdownMenuItem<String>>((StatusEnum value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      Get.find<StatusChangeController>().changeStatus(value!);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GetBuilder<StatusChangeController>(builder: (status) {
                  return ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      _updateTaskStatus(status.selectedStatus!);
                    },
                    child: buttonChild(),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    bool res = await Get.find<TaskController>().deleteTask(taskList.id!);
    if (res) {
      getStatusUpdate();
      await _getTakStatusCount();
      successToast(Messages.taskDeleteSuccess);
      Get.back();
    } else {
      errorToast(Messages.taskDeleteFailed);
    }
  }

  Future<void> _showDeleteAlert(context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Do you really want to delete this task?'),
          actions: [
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: colorRed),
              ),
              onPressed: () async {
                Get.back();
                _deleteTask();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = colorBlue;
    if (taskList.status! == StatusEnum.Progress.name) {
      statusColor = colorPink;
    } else if (taskList.status! == StatusEnum.Completed.name) {
      statusColor = colorGreen;
    } else if (taskList.status! == StatusEnum.Canceled.name) {
      statusColor = colorRed;
    }
    return Card(
      child: itemSizeBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskList.title!,
              style: head2Text(colorDarkBlue),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              taskList.description!,
              style: head3Text(colorGray),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Date: ${taskList.createdDate}",
              style: head4Text(colorDarkBlue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appStatusBar(
                  taskStatus: taskList.status!,
                  backgroundColor: statusColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _showUpdateModal(context, taskList.id!);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: colorGreen,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteAlert(context, taskList.id!);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: colorRed,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
