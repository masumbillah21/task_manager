import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/views/screens/tasks/task_create_screen.dart';
import 'package:task_manager/views/style/style.dart';

class TaskListCard extends StatelessWidget {
  final TaskModel taskList;
  const TaskListCard({
    required this.taskList,
    super.key,
  });

  Future<void> deleteTask(context, String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Do you really want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                await ApiClient().deleteTaskList(id);
                Navigator.of(context).pop();
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
    return Card(
      child: itemSizeBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskList.title,
              style: head6Text(colorDarkBlue),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              taskList.description,
              style: head7Text(colorLightGray),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Date: ${taskList.createdDate}",
              style: head9Text(colorDarkBlue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    taskList.status,
                    style: head7Text(colorWhite),
                  ),
                  backgroundColor: colorGreen,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, TaskCreateScreen.routeName,
                            arguments: taskList);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: colorGreen,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteTask(context, taskList.id);
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
