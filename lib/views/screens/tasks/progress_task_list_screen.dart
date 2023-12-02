import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  static const routeName = "./progress-task";
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  TaskController _taskList = TaskController();
  bool _isLoading = false;

  Future<void> _getTakList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    ApiResponse res = await ApiClient().apiGetRequest(
        url: "${Urls.listTaskByStatus}/${StatusEnum.Progress.name}");
    if (res.isSuccess) {
      _taskList = TaskController.fromJson(res.jsonResponse);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getTakList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _getTakList();
        },
        child: TaskBackgroundContainer(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _taskList.taskList!.isEmpty
                  ? const Center(
                      child: Text(Messages.emptyTask),
                    )
                  : ListView.builder(
                      itemCount: _taskList.taskList?.length ?? 0,
                      itemBuilder: (context, index) => TaskListCard(
                        taskList: _taskList.taskList![index],
                        getStatusUpdate: () {
                          _getTakList();
                        },
                        inProgress: (status) {
                          _isLoading = status;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
        ),
      ),
    );
  }
}
