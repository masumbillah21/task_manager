class TaskCountModel {
  String? id;
  int? sum;

  TaskCountModel({this.id, this.sum});

  TaskCountModel.fromJson(Map<String, dynamic> json) {
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
