import 'package:flutter/material.dart';
import 'package:task_manager/views/style/style.dart';

class TaskBackgroundContainer extends StatelessWidget {
  final Widget child;

  const TaskBackgroundContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorWhite,
      child: Stack(
        children: [
          screenBackground(context),
          child,
        ],
      ),
    );
  }
}
