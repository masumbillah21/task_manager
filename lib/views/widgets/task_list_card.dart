import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/style/style.dart';

class TaskListCard extends StatefulWidget {
  final TaskModel taskList;
  final VoidCallback getStatusUpdate;

  const TaskListCard({
    required this.taskList,
    required this.getStatusUpdate,
    super.key,
  });

  @override
  State<TaskListCard> createState() => _TaskListCardState();
}

class _TaskListCardState extends State<TaskListCard> {
  String _selectedTaskStatus = '';

  Future<void> _updateTaskStatus() async {
    bool res = await Get.find<TaskController>().updateTaskStatus(
        taskId: widget.taskList.id!, status: _selectedTaskStatus);
    if (res) {
      widget.getStatusUpdate();
      successToast(Messages.taskStatusSuccess);
      Get.back();
    } else {
      errorToast(Messages.taskStatusFailed);
    }
  }

  Future<void> _showUpdateModal(String id, String status) async {
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
                    value: widget.taskList.status,
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
                      setState(() {
                        _selectedTaskStatus = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    Get.back();
                    _updateTaskStatus();
                  },
                  child: buttonChild(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask() async {
    bool res = await Get.find<TaskController>().deleteTask(widget.taskList.id!);
    if (res) {
      widget.getStatusUpdate();
      successToast(Messages.taskDeleteSuccess);
      Get.back();
    } else {
      errorToast(Messages.taskDeleteFailed);
    }
  }

  Future<void> _showDeleteAlert(String id) async {
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
    if (widget.taskList.status! == StatusEnum.Progress.name) {
      statusColor = colorPink;
    } else if (widget.taskList.status! == StatusEnum.Completed.name) {
      statusColor = colorGreen;
    } else if (widget.taskList.status! == StatusEnum.Canceled.name) {
      statusColor = colorRed;
    }
    return Card(
      child: itemSizeBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskList.title!,
              style: head2Text(colorDarkBlue),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.taskList.description!,
              style: head3Text(colorGray),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Date: ${widget.taskList.createdDate}",
              style: head4Text(colorDarkBlue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appStatusBar(
                  taskStatus: widget.taskList.status!,
                  backgroundColor: statusColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        _showUpdateModal(
                            widget.taskList.id!, _selectedTaskStatus);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: colorGreen,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteAlert(widget.taskList.id!);
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
