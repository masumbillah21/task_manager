import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/api/api_caller.dart';
import 'package:task_manager/api/api_response.dart';
import 'package:task_manager/utility/task_status.dart';
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

  Future<void> _createNewTask(context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _inProgress = true;
      });
      Map<String, String> formData = {
        'title': _subjectTEController.text.trim(),
        'description': _desTEController.text.trim(),
        'status': TaskStatus.newTask,
      };
      ApiResponse res = await ApiClient().apiPostRequest(
          url: Urls.createTask, formValue: jsonEncode(formData));
      if (res.isSuccess) {
        successToast('Task created successfully');
        _subjectTEController.clear();
        _desTEController.clear();
      } else {
        errorToast(res.errorMessage);
      }
      setState(() {
        _inProgress = false;
      });
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
    return Scaffold(
      appBar: const TaskAppBar(),
      body: TaskBackgroundContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
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
                    decoration: appInputDecoration("Subject"),
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
                    decoration: appInputDecoration("Description"),
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
                        style: appButtonStyle(),
                        child: successButtonChild(),
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
    );
  }
}
