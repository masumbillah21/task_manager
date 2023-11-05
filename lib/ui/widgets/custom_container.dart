import 'package:flutter/material.dart';
import 'package:task_manager/ui/style/style.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;

  const CustomContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        screenBackground(context),
        child,
      ],
    );
  }
}
