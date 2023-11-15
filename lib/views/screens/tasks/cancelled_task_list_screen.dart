import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';
import 'package:task_manager/views/widgets/task_list_card.dart';

class CancelledTaskListScreen extends StatefulWidget {
  static const routeName = "./cancel-task";
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() =>
      _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  List<TaskModel> _taskList = [];
  bool _isLoading = false;

  Future<void> _getTakList() async {
    setState(() {
      _isLoading = true;
    });
    List tasks = await ApiClient().getTaskList('canceled');
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
                        taskList: _taskList[index],
                      ),
                    ),
        ),
      ),
    );
  }
}
