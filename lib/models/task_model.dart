import 'dart:convert';

class TaskModel {
  String? status;
  List<Task>? taskList;

  TaskModel({this.status, this.taskList});

  TaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskList = <Task>[];
      json['data'].forEach((v) {
        taskList!.add(Task.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    if (taskList != null) {
      data['data'] = taskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Task {
  String? id;
  String? title;
  String? description;
  String? status;
  String? createdDate;

  Task({this.id, this.title, this.description, this.status, this.createdDate});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdDate = json['createdDate'];
  }

  String toJson() {
    final Map<String, dynamic> task = Map<String, dynamic>();
    task['_id'] = id;
    task['title'] = title;
    task['description'] = description;
    task['status'] = status;
    task['createdDate'] = createdDate;
    return jsonEncode(task);
  }
}
