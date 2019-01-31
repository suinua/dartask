import 'package:dartask/model/task.dart';
import 'package:dartask/model/user.dart';
import 'package:dartask/view/pages/task_list_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _taskGroupListRef =
    FirebaseDatabase.instance.reference().child('task_group_list');

class TaskGroup {
  String key;

  User owner;
  String title;
  List<Task> _taskList;

  bool operator ==(o) => o is TaskGroup && o.key == key;

  TaskGroup(this.title, {this.owner, this.key}) {
    _taskList = <Task>[];
    if (key != null) {
      final _taskGroupRef = _taskGroupListRef.child(key);

      _taskGroupRef
          .child('owner')
          .child('title')
          .onChildChanged
          .listen((event) {
        title = event.snapshot.value;
      });

      _taskGroupRef.child('task_list').onChildAdded.listen((event) {
        if (event.snapshot.value is Map) {
          print('add task:${event.snapshot.value}');
          if (event.snapshot.key != 'owner') {
            _taskList.add(Task(
              event.snapshot.value['text'],
              isComplete: event.snapshot.value['isComplete'],
              parentKey: this.key,
              key: event.snapshot.key,
            ));
          }
        }
      });

      _taskGroupRef.child('task_list').onChildRemoved.listen((event) {
        if (event.snapshot.value is Map) {
          print('remove task:${event.snapshot.value}');
          _taskList.remove(Task(
            event.snapshot.value['text'],
            isComplete: event.snapshot.value['isComplete'],
            parentKey: this.key,
            key: event.snapshot.key,
          ));
        }
      });
    }
  }

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
    _taskGroupListRef
        .child(this.key)
        .child('task_list')
        .push()
        .set(task.asMap());
  }

  Map<String, dynamic> asMap() => {
        'owner': this.owner.asMap(),
        'title': this.title,
        'taskList': this._taskList.map((task) => task.asMap()).toList(),
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
                TaskListPage(taskGroup: taskGroup),
          ),
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
