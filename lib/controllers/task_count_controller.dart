import 'package:task_manager/models/task_count_model.dart';

class TaskCountController {
  String? status;
  List<TaskCountModel>? taskStatusCount;

  TaskCountController({this.status, this.taskStatusCount});

  TaskCountController.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCount = <TaskCountModel>[];
      json['data'].forEach((v) {
        taskStatusCount!.add(TaskCountModel.fromJson(v));
      });
    }
  }

  int getByStatus(String status) {
    TaskCountModel? taskCount = taskStatusCount?.firstWhere(
        (element) => element.id == status,
        orElse: () => TaskCountModel());

    return taskCount?.sum ?? 0;
  }
}
