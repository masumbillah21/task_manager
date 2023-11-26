class TaskStatusCountModel {
  String? status;
  List<TaskCount>? taskStatusCount;

  TaskStatusCountModel({this.status, this.taskStatusCount});

  TaskStatusCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCount = <TaskCount>[];
      json['data'].forEach((v) {
        taskStatusCount!.add(new TaskCount.fromJson(v));
      });
    }
  }
}

class TaskCount {
  String? sId;
  int? sum;

  TaskCount({this.sId, this.sum});

  TaskCount.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sum'] = this.sum;
    return data;
  }
}
