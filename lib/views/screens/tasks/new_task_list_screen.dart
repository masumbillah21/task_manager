import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final SharedPreferences sp = await SharedPreferences.getInstance();
    print("User: ${sp.getString('user')}");
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
                  _getTakList();
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
