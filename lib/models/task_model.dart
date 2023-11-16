class TaskModel {
  String? id;
  String title;
  String description;
  String status;
  String? createdDate;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    this.createdDate,
  });

  factory TaskModel.fromJson(Map<String, dynamic> task) {
    return TaskModel(
        id: task['_id'],
        title: task['title'],
        description: task['description'],
        status: task['status'],
        createdDate: task['createdDate']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> taskData = <String, dynamic>{};
    taskData['_id'] = id;
    taskData['title'] = title;
    taskData['description'] = description;
    taskData['status'] = status;
    return taskData;
  }
}
