import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/utility/urls.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_app_bar.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class TaskCreateScreen extends StatefulWidget {
  static const routeName = "./task-create";

  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _desTEController = TextEditingController();
  bool _inProgress = false;
  bool _taskAdded = false;

  Future<void> _createNewTask(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _inProgress = true;
      });
      Map<String, String> formData = {
        'title': _subjectTEController.text.trim(),
        'description': _desTEController.text.trim(),
        'status': StatusEnum.New.name,
      };
      ApiResponse res = await ApiClient().apiPostRequest(
          url: Urls.createTask, formValue: jsonEncode(formData));
      if (res.isSuccess) {
        successToast(Messages.createTaskSuccess);
        _subjectTEController.clear();
        _desTEController.clear();
        _taskAdded = true;
        if (mounted) {
          setState(() {});
        }
      } else {
        errorToast(Messages.createTaskFailed);
      }
      if (mounted) {
        setState(() {
          _inProgress = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _subjectTEController.dispose();
    _desTEController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (onPop) {
        if (onPop) {
          return;
        }
        Navigator.pop(context, _taskAdded);
      },
      child: Scaffold(
        appBar: const TaskAppBar(),
        body: TaskBackgroundContainer(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Add New Task",
                      style: head1Text(colorDarkBlue),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _subjectTEController,
                      decoration: const InputDecoration(label: Text("Subject")),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Subject is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: _desTEController,
                      maxLines: 10,
                      decoration:
                          const InputDecoration(label: Text("Description")),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: Visibility(
                        visible: _inProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          child: buttonChild(),
                          onPressed: () {
                            _createNewTask(context);
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
      ),
    );
  }
}
