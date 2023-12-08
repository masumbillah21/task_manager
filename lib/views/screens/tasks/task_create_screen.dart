import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/controllers/task_controller.dart';
import 'package:task_manager/utility/messages.dart';
import 'package:task_manager/utility/status_enum.dart';
import 'package:task_manager/views/style/style.dart';
import 'package:task_manager/views/widgets/task_app_bar.dart';
import 'package:task_manager/views/widgets/task_background_container.dart';

class TaskCreateScreen extends StatefulWidget {
  static const routeName = "/task-create";

  const TaskCreateScreen({super.key});

  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _desTEController = TextEditingController();

  Future<void> _createNewTask() async {
    if (_formKey.currentState!.validate()) {
      bool res = await Get.find<TaskController>().createNewTask(
        title: _subjectTEController.text.trim(),
        description: _desTEController.text.trim(),
      );
      if (res) {
        successToast(Messages.createTaskSuccess);
        _subjectTEController.clear();
        _desTEController.clear();
        Get.find<TaskController>().getTakList(StatusEnum.New);
      } else {
        errorToast(Messages.createTaskFailed);
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
        Navigator.pop(context);
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
                      child: GetBuilder<TaskController>(builder: (task) {
                        return Visibility(
                          visible: task.inProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                            child: buttonChild(),
                            onPressed: () {
                              _createNewTask();
                            },
                          ),
                        );
                      }),
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
