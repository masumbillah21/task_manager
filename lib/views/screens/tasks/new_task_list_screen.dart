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
  TaskModel _taskList = TaskModel();
  TaskStatusCountModel _taskStatusCount = TaskStatusCountModel();
  bool _isLoading = false;
  bool _isCountLoading = false;
  String _selectedTaskStatus = '';

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

  Future<void> _getTakList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    ApiResponse res = await ApiClient()
        .apiGetRequest(url: "${Urls.listTaskByStatus}/${TaskStatus.newTask}");
    if (res.isSuccess) {
      _taskList = TaskModel.fromJson(res.jsonResponse);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTaskStatus(String id, String status) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        height: 400,
        child: Column(
          children: [
            Text(
              "Update Task Status",
              style: head1Text(colorGreen),
            ),
            const Divider(
              height: 20,
              color: colorGreen,
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: status,
                  isExpanded: true,
                  decoration: appInputDecoration('Task Status'),
                  items: TaskStatus.taskStatusList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTaskStatus = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                    await ApiClient().updateTaskStatus(id, _selectedTaskStatus);
                  },
                  style: appButtonStyle(),
                  child: successButtonChild(),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
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
                                .getByStatus(TaskStatus.newTask),
                            taskStatus: TaskStatus.newTask,
                          ),
                          CounterContainer(
                            taskNumber: _taskStatusCount
                                .getByStatus(TaskStatus.inProgressTask),
                            taskStatus: TaskStatus.inProgressTask,
                          ),
                          CounterContainer(
                            taskNumber: _taskStatusCount
                                .getByStatus(TaskStatus.completedTask),
                            taskStatus: TaskStatus.completedTask,
                          ),
                          CounterContainer(
                            taskNumber: _taskStatusCount
                                .getByStatus(TaskStatus.canceledTask),
                            taskStatus: TaskStatus.canceledTask,
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
                                child: Text('Task is empty.'),
                              )
                            : ListView.builder(
                                itemCount: _taskList.taskList?.length ?? 0,
                                itemBuilder: (context, index) => TaskListCard(
                                  deleteTask: _deleteTask,
                                  editTask: _updateTaskStatus,
                                  taskList: _taskList.taskList![index],
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
