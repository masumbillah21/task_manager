import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/views/style/style.dart';

class ProfileImagePicker extends StatelessWidget {
  final VoidCallback onTab;
  final XFile? photoLink;
  const ProfileImagePicker({
    required this.onTab,
    this.photoLink,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = 50.0;
    return GestureDetector(
      onTap: onTab,
      child: Container(
        alignment: Alignment.centerLeft,
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              width: 120,
              height: height,
              decoration: const BoxDecoration(
                color: colorDarkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: const Text(
                'Upload Photo',
                style: TextStyle(
                  color: colorWhite,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(photoLink?.name ?? ''),
            )),
          ],
        ),
      ),
    );
  }
}
