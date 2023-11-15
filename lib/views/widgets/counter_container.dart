import 'package:flutter/material.dart';
import 'package:task_manager/views/style/style.dart';

class CounterContainer extends StatelessWidget {
  final int taskNumber;
  final String taskStatus;
  const CounterContainer({
    required this.taskNumber,
    required this.taskStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$taskNumber",
              style: head1Text(Colors.black),
            ),
            Text(taskStatus),
          ],
        ),
      ),
    );
  }
}
