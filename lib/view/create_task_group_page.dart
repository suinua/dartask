import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/model/task_group.dart';
import 'package:flutter/material.dart';

class CreateTaskGroupPage extends StatefulWidget {
  _CreateTaskGroupPageState createState() => _CreateTaskGroupPageState();
}

class _CreateTaskGroupPageState extends State<CreateTaskGroupPage> {
  String _titleText = '';

  bool _canSave() {
    return _titleText.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = TaskGroupListBlocProvider.of(context);
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
                      bloc.increment.add(TaskGroup(_titleText));
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
              onChanged: (value){
                setState(() {
                  _titleText = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
