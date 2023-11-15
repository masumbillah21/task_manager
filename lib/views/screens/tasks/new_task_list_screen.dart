import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/models/task_model.dart';
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
  List _taskList = [];
  bool _isLoading = false;

  Future<void> _getTakList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    List tasks = await ApiClient().getTaskList('New');
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

  @override
  void initState() {
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
            Navigator.pushNamed(context, TaskCreateScreen.routeName)
                .then((_) => _getTakList());
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
                            const SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CounterContainer(
                                    taskNumber: 9,
                                    taskStatus: 'New',
                                  ),
                                  CounterContainer(
                                    taskNumber: 9,
                                    taskStatus: 'Progress',
                                  ),
                                  CounterContainer(
                                    taskNumber: 9,
                                    taskStatus: 'Completed',
                                  ),
                                  CounterContainer(
                                    taskNumber: 9,
                                    taskStatus: 'Cancelled',
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _taskList.length,
                                itemBuilder: (context, index) => TaskListCard(
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
