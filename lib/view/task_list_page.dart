import 'package:dartask/view/task_group_setting_widget.dart';
import 'package:dartask/view/widgets/floating_button_widget.dart';
import 'package:dartask/model/task.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/widget_colors.dart';
import 'package:flutter/material.dart';

class TaskListPage extends StatefulWidget {
  final TaskGroup taskGroup;

  const TaskListPage({Key key, @required this.taskGroup}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  bool _showCompleted = false;
  bool _showSettingMenu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingButtonWidget(
        text: 'Task',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return _CreateTaskBottomSheet();
            },
          ).then((value) {
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
                  icon: _showCompleted
                      ? Icon(Icons.keyboard_arrow_down)
                      : Icon(Icons.keyboard_arrow_up),
                  onPressed: () {
                    setState(() {
                      _showCompleted = !_showCompleted;
                    });
                  },
                ),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _showCompleted ? 200 : 0,
              child: _buildTaskList(widget.taskGroup.completedTaskList()),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white30,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.black26,
            ),
            onPressed: () {
              _showSettingMenu = !_showSettingMenu;
            },
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              widget.taskGroup.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
          Divider(),
          //todo ここに設定画面を表示させる、animatedContainerで
          _showSettingMenu
              ? TaskGroupSettingWidget()
              : Expanded(
                  child:
                      _buildTaskList(widget.taskGroup.notCompletedTaskList()),
                ),
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
  _CreateTaskBottomSheetState createState() => _CreateTaskBottomSheetState();
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
            color: WidgetColors.button,
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
