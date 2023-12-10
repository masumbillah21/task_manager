import 'package:get/get.dart';

class StatusChangeController extends GetxController {
  String? selectedStatus;

  void changeStatus(String status) {
    selectedStatus = status;
    update();
  }
}
