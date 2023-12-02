import 'package:task_manager/models/task_model.dart';

class TaskController {
  String? status;
  List<TaskModel>? taskList;

  TaskController({this.status, this.taskList});

  TaskController.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskList = <TaskModel>[];
      json['data'].forEach((v) {
        taskList!.add(TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (taskList != null) {
      data['data'] = taskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
