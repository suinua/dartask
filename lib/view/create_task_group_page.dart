import 'package:dartask/bloc/task_group_list_bloc.dart';
import 'package:dartask/model/task_group.dart';
import 'package:flutter/material.dart';

class CreateTaskGroupPage extends StatefulWidget {
  final TaskGroupListBloc bloc;

  const CreateTaskGroupPage({Key key, @required this.bloc}) : super(key: key);

  _CreateTaskGroupPageState createState() => _CreateTaskGroupPageState();
}

class _CreateTaskGroupPageState extends State<CreateTaskGroupPage> {
  final TextEditingController _titleTextController = TextEditingController();

  bool _canSave() {
    return _titleTextController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: const Text('新しいタスクグループ'),
        centerTitle: true,
        actions: <Widget>[
          Center(
            child: RaisedButton(
              color: Colors.orangeAccent,
              onPressed: _canSave()
                  ? () {
                      Navigator.pop(context);
                      widget.bloc.increment.add(TaskGroup(_titleTextController.text));
                    }
                  : null,
              child: Text('＋ 追加'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _titleTextController,
            ),
          ),
        ],
      ),
    );
  }
}
