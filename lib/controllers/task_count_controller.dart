import 'package:get/get.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/task_count_model.dart';
import 'package:task_manager/utility/urls.dart';

class TaskCountController extends GetxController {
  List<TaskCountModel>? _taskStatusCount;
  bool _isCountLoading = false;

  bool get isCountLoading => _isCountLoading;

  int getByStatus(String status) {
    TaskCountModel? taskCount = _taskStatusCount?.firstWhere(
        (element) => element.id == status,
        orElse: () => TaskCountModel());

    return taskCount?.sum ?? 0;
  }

  Future<bool> getTakStatusCount() async {
    _isCountLoading = true;
    update();

    ApiResponse res =
        await ApiClient().apiGetRequest(url: Urls.taskStatusCount);
    _isCountLoading = false;
    update();
    if (res.isSuccess) {
      if (res.jsonResponse['data'] != null) {
        _taskStatusCount = <TaskCountModel>[];
        res.jsonResponse['data'].forEach((v) {
          _taskStatusCount!.add(TaskCountModel.fromJson(v));
        });
      }
      update();
      return true;
    }
    return false;
  }
}
