import 'package:flutter/material.dart';
import 'package:task_manager/api/api_client.dart';
import 'package:task_manager/ui/screens/onboarding/login_screen.dart';
import 'package:task_manager/ui/screens/tasks/task_create_screen.dart';
import 'package:task_manager/ui/style/style.dart';
import 'package:task_manager/ui/widgets/counter_container.dart';
import 'package:task_manager/ui/widgets/custom_container.dart';
import 'package:task_manager/ui/widgets/task_list_card.dart';

class NewTaskListScreen extends StatefulWidget {
  static const routeName = "./new-task";
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  Future<void> logOut(context) async {
    bool isLogout = await ApiClient().userLogout();
    if (isLogout) {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: colorGreen,
          onPressed: () {
            Navigator.pushNamed(context, TaskCreateScreen.routeName);
          },
          child: const Icon(Icons.add),
        ),
        body: CustomContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    itemCount: 9,
                    itemBuilder: (context, index) => const TaskListCard(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
