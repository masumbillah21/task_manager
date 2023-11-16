import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  static const routeName = "./progress-task";
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  List<TaskModel> _taskList = [];
  bool _isLoading = false;

  Future<void> _getTakList() async {
    setState(() {
      _isLoading = true;
    });
    List tasks = await ApiClient().getTaskList('Progress');
    List<TaskModel> taskData = [];
    if (tasks.isNotEmpty) {
      final parsed = tasks.cast<Map<String, dynamic>>();
      taskData =
          parsed.map<TaskModel>((json) => TaskModel.fromJson(json)).toList();
    }

    setState(() {
      _isLoading = false;
      _taskList = taskData;
    });
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
                await ApiClient().deleteTaskList(id);
                if (mounted) {
                  Navigator.of(context).pop();
                }
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
              : _taskList.isEmpty
                  ? const Center(
                      child: Text('Task is empty.'),
                    )
                  : ListView.builder(
                      itemCount: _taskList.length,
                      itemBuilder: (context, index) => TaskListCard(
                        deleteTask: _deleteTask,
                        taskList: _taskList[index],
                      ),
                    ),
        ),
      ),
    );
  }
}
