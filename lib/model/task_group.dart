import 'package:dartask/model/task.dart';
import 'package:dartask/view/task_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskGroup {
  TaskGroup(this.title) : _taskList = <Task>[];

  String title;
  List<Task> _taskList;

  List<Task> allTaskList() => _taskList;

  List<Task> completedTaskList() =>
      _taskList.where((task) => task.isComplete).toList();

  List<Task> notCompletedTaskList() =>
      _taskList.where((task) => !task.isComplete).toList();

  double getProgress() {
    if (_taskList.isEmpty) {
      return 0.0;
    } else {
      return completedTaskList().length / _taskList.length * 100;
    }
  }

  void addTask(Task task) {
    _taskList.add(task);
  }

  Map<String, dynamic> asMap() => {
        'title': this.title,
        'taskList': _taskList.map((task) => task.asMap()).toList(),
      };

  Widget asWidget(BuildContext context) => _TaskGroupWidget(taskGroup: this);
}

class _TaskGroupWidget extends StatelessWidget {
  final TaskGroup taskGroup;

  const _TaskGroupWidget({Key key, @required this.taskGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  TaskListPage(taskGroup: taskGroup)),
        );
      },
      child: Container(
        width: 150,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                this.taskGroup.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              Stack(
                children: <Widget>[
                  Container(
                    height: 15.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: null,
                  ),
                  Container(
                    height: 15.0,
                    width: taskGroup.getProgress(),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: null,
                  ),
                  Container(
                    height: 15.0,
                    width: 100.0,
                    child: Center(
                        child: Text(
                            '${taskGroup.completedTaskList().length} / ${taskGroup.allTaskList().length}')),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
