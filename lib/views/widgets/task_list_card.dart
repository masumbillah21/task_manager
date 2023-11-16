import 'package:flutter/material.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/views/style/style.dart';

class TaskListCard extends StatelessWidget {
  final TaskModel taskList;
  final Function(String id) deleteTask;
  const TaskListCard({
    required this.taskList,
    required this.deleteTask,
    super.key,
  });

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
                        // TODO: Show Status Option
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: colorGreen,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteTask(taskList.id!);
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
