import 'package:dartask/model/task.dart';
import 'package:dartask/model/task_group.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  final TaskGroup taskGroup;

  const TaskListPage({Key key, @required this.taskGroup}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  bool showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.add),
        label: Text('Task'),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return _CreateTaskBottomSheet();
              }).then((value) {
            if (value != null) {
              setState(() {
                widget.taskGroup.addTask(value);
              });
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(icon: Icon(Icons.menu), onPressed: () {}),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_up),
                  onPressed: () {
                    setState(() {
                      showCompleted = !showCompleted;
                    });
                  },
                ),
              ],
            ),
            AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: showCompleted ? 200 : 0,
                child: _buildTaskList(widget.taskGroup
                    .getTaskList()
                    .where((Task task) => task.isComplete)
                    .toList())),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.taskGroup.title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: _buildTaskList(widget.taskGroup
                  .getTaskList()
                  .where((Task task) => !task.isComplete)
                  .toList())),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> taskList) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (BuildContext context, int index) {
        return taskList[index].asWidget(update: () {
          setState(() {});
        });
      },
    );
  }
}

class _CreateTaskBottomSheet extends StatefulWidget {
  @override
  _CreateTaskBottomSheetState createState() =>  _CreateTaskBottomSheetState();
}

class _CreateTaskBottomSheetState extends State<_CreateTaskBottomSheet> {
  String _newTaskText = '';

  bool canSave() {
    return _newTaskText.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _newTaskText = value;
                });
              },
            ),
          ),
          RaisedButton(
            color: Colors.orangeAccent,
            onPressed: canSave()
                ? () {
                    Navigator.pop(context, Task(_newTaskText));
                  }
                : null,
            child: const Text('追加'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ],
      ),
    );
  }
}
