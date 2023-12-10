import 'dart:convert';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoController extends GetxController {
  final ImagePicker picker = ImagePicker();
  String? photoInBase64;
  XFile? _imageFile;
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
      photoInBase64 = base64Encode(imageBytes);
      _imageFile = photo;
      update();
      return true;
    }
    return false;
  }
}
