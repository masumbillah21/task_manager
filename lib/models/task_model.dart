import 'dart:convert';

class TaskModel {
  String? id;
  String? title;
  String? description;
  String? status;
  String? createdDate;

  TaskModel(
      {this.id, this.title, this.description, this.status, this.createdDate});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdDate = json['createdDate'];
  }

  String toJson() {
    final Map<String, dynamic> task = <String, dynamic>{};
    task['_id'] = id;
    task['title'] = title;
    task['description'] = description;
    task['status'] = status;
    task['createdDate'] = createdDate;
    return jsonEncode(task);
  }
}
