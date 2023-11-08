import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/tasks/task_create_screen.dart';
import 'package:task_manager/ui/style/style.dart';

class TaskListCard extends StatelessWidget {
  const TaskListCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title",
              style: head6Text(Colors.black),
            ),
            Text(
              "Description",
              style: head7Text(Colors.black),
            ),
            Text(
              "Date: 01/01/2022",
              style: head7Text(Colors.black),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    'New',
                    style: head7Text(colorWhite),
                  ),
                  backgroundColor: colorGreen,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, TaskCreateScreen.routeName);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: colorGreen,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
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
