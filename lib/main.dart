import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_manager/views/screens/task_manager_app.dart';

void main() async {
  await GetStorage.init();
  runApp(const TaskManagerApp());
}
