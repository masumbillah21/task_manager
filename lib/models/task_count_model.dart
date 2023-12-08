class TaskCountModel {
  String? id;
  int? sum;

  TaskCountModel({this.id, this.sum});

  TaskCountModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    sum = json['sum'];
  }
}
