import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/controllers/auth_controller.dart';

class PhotoController extends GetxController {
  final ImagePicker picker = ImagePicker();
  String? _photoInBase64 = Get.find<AuthController>().user?.photo;
  XFile? _imageFile;

  String? get photoInBase64 => _photoInBase64;
  XFile? get imageFile => _imageFile;

  Future<bool> takePhoto({bool isGallery = false}) async {
    final XFile? photo;
    if (isGallery) {
      photo = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 400,
        maxWidth: 400,
      );
    } else {
      photo = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 400,
        maxWidth: 400,
      );
    }

    if (photo != null) {
      List<int> imageBytes = await photo.readAsBytes();
      _photoInBase64 = base64Encode(imageBytes);
      _imageFile = photo;
      update();
      return true;
    }
    return false;
  }
}
