import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/widget_colors.dart';
import 'package:flutter/material.dart';

class TaskGroupSettingPage extends StatefulWidget {
  final TaskGroup taskGroup;

  const TaskGroupSettingPage({Key key, @required this.taskGroup})
      : super(key: key);

  @override
  TaskGroupSettingPageState createState() {
    return TaskGroupSettingPageState();
  }
}

class TaskGroupSettingPageState extends State<TaskGroupSettingPage> {
  TextEditingController _titleController = TextEditingController();

  bool canSave() {
    return widget.taskGroup.title != _titleController.text;
  }

  void updateGroup() {
    widget.taskGroup..title = _titleController.text;
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.taskGroup.title;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = TaskGroupListBlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white30,
        actions: <Widget>[
          Center(
            child: RaisedButton(
              color: WidgetColors.button,
              onPressed: canSave()
                  ? () {
                      updateGroup();
                      bloc.updateGroup.add(widget.taskGroup);
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('保存'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Theme(
              data: ThemeData(primaryColor: WidgetColors.border),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  fillColor: WidgetColors.border,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Center(
            child: RaisedButton(
              color: Colors.red,
              onPressed: () {
                bloc.removeGroup.add(widget.taskGroup);
                //todo
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('削除'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
