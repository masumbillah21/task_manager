import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/task_count_status_model.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/utility/task_status.dart';
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
  List<TaskModel> _taskList = [];
  TaskStatusCountModel _taskStatusCount = TaskStatusCountModel();
  bool _isLoading = false;
  bool _isCountLoading = false;

  Future<void> _getTakList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    List tasks = await ApiClient().getTaskList(TaskStatus.newTask);
    List<TaskModel> taskData = [];
    if (tasks.isNotEmpty) {
      final parsed = tasks.cast<Map<String, dynamic>>();
      taskData =
          parsed.map<TaskModel>((json) => TaskModel.fromJson(json)).toList();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
        _taskList = taskData;
      });
    }
  }

  Future<void> _getTakStatusCount() async {
    if (mounted) {
      setState(() {
        _isCountLoading = true;
      });
    }

    ApiResponse res =
        await ApiClient().apiGetRequest(url: Urls.taskStatusCount);

    if (res.isSuccess) {
      _taskStatusCount = TaskStatusCountModel.fromJson(res.jsonResponse);
    }

    if (mounted) {
      setState(() {
        _isCountLoading = false;
      });
    }
  }

  Future<void> _deleteTask(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Do you really want to delete this task?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                if (mounted) {
                  Navigator.of(context).pop();
                  _getTakList();
                }
                await ApiClient().deleteTaskList(id);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          backgroundColor: colorGreen,
          onPressed: () {
            Navigator.pushNamed(context, TaskCreateScreen.routeName,
                arguments: {}).then((_) => _getTakList());
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
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _taskList.isEmpty
                      ? const Center(
                          child: Text('Task is empty.'),
                        )
                      : Column(
                          children: [
                            Visibility(
                              visible: !_isCountLoading,
                              replacement: const Center(
                                child: LinearProgressIndicator(),
                              ),
                              child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _taskStatusCount
                                          .taskStatusCount?.length ??
                                      0,
                                  itemBuilder: (context, index) =>
                                      CounterContainer(
                                    taskNumber: _taskStatusCount
                                        .taskStatusCount![index].sum!,
                                    taskStatus: _taskStatusCount
                                        .taskStatusCount![index].sId!,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _taskList.length,
                                itemBuilder: (context, index) => TaskListCard(
                                  deleteTask: _deleteTask,
                                  taskList: _taskList[index],
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
