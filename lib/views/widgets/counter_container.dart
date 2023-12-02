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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 90),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskNumber > 0 ? taskNumber.toString().padLeft(2, '0') : '0',
                style: head2Text(Colors.black),
              ),
              Text(
                taskStatus,
                style: head5Text(colorDarkBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
