import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/utility/task_status.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/style/style.dart';
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
  TaskModel _taskList = TaskModel();
  bool _isLoading = false;
  String _selectedTaskStatus = '';

  Future<void> _getTakList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    ApiResponse res = await ApiClient().apiGetRequest(
        url: "${Urls.listTaskByStatus}/${TaskStatus.canceledTask}");
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
      ),
    );
  }
}
