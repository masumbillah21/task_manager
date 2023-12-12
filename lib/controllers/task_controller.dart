import 'package:get/get.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/utility/urls.dart';

class TaskController extends GetxController {
  List<TaskModel>? _newTaskList = [];
  List<TaskModel>? _progressTaskList = [];
  List<TaskModel>? _completeTaskList = [];
  List<TaskModel>? _cancelTaskList = [];

  bool _isNewTaskCalled = false;
  bool _isProgressTaskCalled = false;
  bool _isCompleteTaskCalled = false;
  bool _isCancelTaskCalled = false;

  bool _inProgress = false;

  bool get inProgress => _inProgress;

  List<TaskModel>? get newTaskList => _newTaskList;
  List<TaskModel>? get progressTaskList => _progressTaskList;
  List<TaskModel>? get completeTaskList => _completeTaskList;
  List<TaskModel>? get cancelTaskList => _cancelTaskList;

  bool get isNewTaskCalled => _isNewTaskCalled;
  bool get isProgressTaskCalled => _isProgressTaskCalled;
  bool get isCompleteTaskCalled => _isCompleteTaskCalled;
  bool get isCancelTaskCalled => _isCancelTaskCalled;

  Future<bool> createNewTask(
      {required String title, required String description}) async {
    _inProgress = true;
    update();

    TaskModel formData = TaskModel(
      title: title,
      description: description,
      status: StatusEnum.New.name,
    );
    ApiResponse res = await ApiClient().apiPostRequest(
      url: Urls.createTask,
      formValue: formData.toJson(),
    );
    _inProgress = false;
    update();
    if (res.isSuccess) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getTakList(String status) async {
    _inProgress = true;
    print("Get task called $status");
    update();

    ApiResponse res = await ApiClient()
        .apiGetRequest(url: "${Urls.listTaskByStatus}/$status");
    _inProgress = false;
    update();
    if (res.isSuccess) {
      if (res.jsonResponse['data'] != null) {
        List<TaskModel>? taskList = <TaskModel>[];

        res.jsonResponse['data'].forEach((v) {
          taskList.add(TaskModel.fromJson(v));
        });

        if (status == StatusEnum.New.name) {
          _newTaskList = taskList;
          if (!_isNewTaskCalled) {
            _isNewTaskCalled = true;
          }
        } else if (status == StatusEnum.Progress.name) {
          _progressTaskList = taskList;
          if (!_isProgressTaskCalled) {
            _isProgressTaskCalled = true;
          }
        } else if (status == StatusEnum.Completed.name) {
          _completeTaskList = taskList;
          if (!_isCompleteTaskCalled) {
            _isCompleteTaskCalled = true;
          }
        } else if (status == StatusEnum.Canceled.name) {
          _cancelTaskList = taskList;
          if (!_isCancelTaskCalled) {
            _isCancelTaskCalled = true;
          }
        }
      }
      update();
      return true;
    }

    return false;
  }

  Future<bool> updateTaskStatus(
      {required String taskId, required String status}) async {
    _inProgress = true;
    print('Update called');
    update();

    ApiResponse res = await ApiClient()
        .apiGetRequest(url: Urls.updateTaskStatus(taskId, status));
    _inProgress = false;
    update();
    if (res.isSuccess) {
      return true;
    } else {
      return true;
    }
  }

  Future<bool> deleteTask(String taskId) async {
    _inProgress = true;
    update();

    ApiResponse res =
        await ApiClient().apiGetRequest(url: Urls.deleteTask(taskId));
    _inProgress = false;
    update();
    if (res.isSuccess) {
      return true;
    } else {
      return false;
    }
  }
}
