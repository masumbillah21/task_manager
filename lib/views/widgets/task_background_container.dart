import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          SvgPicture.asset(
            'assets/images/background.svg',
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          child,
        ],
      ),
    );
  }
}
