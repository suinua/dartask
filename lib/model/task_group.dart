import 'package:dartask/model/task.dart';
import 'package:dartask/view/task_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskGroup {
  TaskGroup(this.title) : _taskList = <Task>[];

  String title;
  List<Task> _taskList;

  List<Task> getTaskList() => _taskList;

  void addTask(Task task) {
    _taskList.add(task);
  }

  Widget asWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => TaskListPage(taskGroup: this)),
        );
      },
      child: Container(
        width: 150,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                this.title,
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
