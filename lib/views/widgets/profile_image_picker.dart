import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task_manager/views/style/style.dart';

class ProfileImagePicker extends StatelessWidget {
  final VoidCallback onTab;
  final File? photoLink;
  const ProfileImagePicker({
    required this.onTab,
    this.photoLink,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        alignment: Alignment.center,
        child: CircleAvatar(
          radius: 80,
          backgroundColor: colorWhite,
          backgroundImage: const AssetImage('assets/images/placeholder.png'),
          child: Icon(
            Icons.camera_alt,
            size: 50,
            color: colorGreen.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
