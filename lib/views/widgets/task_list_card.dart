import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/style/style.dart';

class TaskListCard extends StatefulWidget {
  final TaskModel taskList;
  final VoidCallback getStatusUpdate;
  final Function(bool) inProgress;

  const TaskListCard({
    required this.taskList,
    required this.getStatusUpdate,
    required this.inProgress,
    super.key,
  });

  @override
  State<TaskListCard> createState() => _TaskListCardState();
}

class _TaskListCardState extends State<TaskListCard> {
  String _selectedTaskStatus = '';

  Future<void> _updateTaskStatus() async {
    widget.inProgress(true);
    if (mounted) {
      setState(() {});
    }

    ApiResponse res = await ApiClient().apiGetRequest(
        url: Urls.updateTaskStatus(widget.taskList.id!, _selectedTaskStatus));
    if (res.isSuccess) {
      widget.getStatusUpdate();
      successToast(Messages.taskStatusSuccess);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      errorToast(res.errorMessage);
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
                    if (mounted) {
                      Navigator.pop(context);
                    }
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
    widget.inProgress(true);
    if (mounted) {
      setState(() {});
    }

    ApiResponse res = await ApiClient()
        .apiGetRequest(url: Urls.deleteTask(widget.taskList.id!));
    if (res.isSuccess) {
      widget.getStatusUpdate();
      successToast(Messages.taskDeleteSuccess);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      errorToast(res.errorMessage.toString());
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
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: colorRed),
              ),
              onPressed: () async {
                if (mounted) {
                  Navigator.of(context).pop();
                }
                _deleteTask();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
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
