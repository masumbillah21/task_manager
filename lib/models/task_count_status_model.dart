class TaskStatusCountModel {
  String? status;
  List<TaskCount>? taskStatusCount;

  TaskStatusCountModel({this.status, this.taskStatusCount});

  TaskStatusCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCount = <TaskCount>[];
      json['data'].forEach((v) {
        taskStatusCount!.add(TaskCount.fromJson(v));
      });
    }
  }

  int getByStatus(String status) {
    TaskCount taskCount = taskStatusCount!.firstWhere(
        (element) => element.id == status,
        orElse: () => TaskCount());

    return taskCount.sum ?? 0;
  }
}

class TaskCount {
  String? id;
  int? sum;

  TaskCount({this.id, this.sum});

  TaskCount.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['sum'] = sum;
    return data;
  }
}
