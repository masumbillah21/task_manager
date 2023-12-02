import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/controllers/task_count_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/screens/tasks/task_create_screen.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/counter_container.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class NewTaskListScreen extends StatefulWidget {
  static const routeName = "./new-task";
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  TaskController _taskList = TaskController();
  TaskCountController _taskStatusCount = TaskCountController();
  bool _isLoading = false;
  bool _isCountLoading = false;

  Future<void> _getTakStatusCount() async {
    if (mounted) {
      setState(() {
        _isCountLoading = true;
      });
    }

    ApiResponse res =
        await ApiClient().apiGetRequest(url: Urls.taskStatusCount);

    if (res.isSuccess) {
      _taskStatusCount = TaskCountController.fromJson(res.jsonResponse);
    }

    if (mounted) {
      setState(() {
        _isCountLoading = false;
      });
    }
  }

  Future<void> _getTakList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    ApiResponse res = await ApiClient()
        .apiGetRequest(url: "${Urls.listTaskByStatus}/${StatusEnum.New.name}");
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
    _getTakStatusCount();
    _getTakList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 3.0,
          backgroundColor: colorGreen,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () async {
            final res =
                await Navigator.pushNamed(context, TaskCreateScreen.routeName);
            if (res == true) {
              _getTakStatusCount();
              _getTakList();
            }
          },
          child: const Icon(Icons.add),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _getTakList();
          },
          child: TaskBackgroundContainer(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Visibility(
                    visible: !_isCountLoading,
                    replacement: const Center(
                      child: LinearProgressIndicator(),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CounterContainer(
                            taskNumber: _taskStatusCount
                                .getByStatus(StatusEnum.New.name),
                            taskStatus: StatusEnum.New.name,
                          ),
                          CounterContainer(
                            taskNumber: _taskStatusCount
                                .getByStatus(StatusEnum.Progress.name),
                            taskStatus: StatusEnum.Progress.name,
                          ),
                          CounterContainer(
                            taskNumber: _taskStatusCount
                                .getByStatus(StatusEnum.Completed.name),
                            taskStatus: StatusEnum.Completed.name,
                          ),
                          CounterContainer(
                            taskNumber: _taskStatusCount
                                .getByStatus(StatusEnum.Canceled.name),
                            taskStatus: StatusEnum.Canceled.name,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
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
                                    _getTakStatusCount();
                                    _getTakList();
                                  },
                                  inProgress: (status) {
                                    _isCountLoading = status;
                                    _isLoading = status;
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
