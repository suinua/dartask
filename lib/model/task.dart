import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String text;
  bool isComplete;

  Task(this.text) : isComplete = false;

  Widget asWidget(){
    return _TaskWidget(task: this);
  }
}

class _TaskWidget extends StatefulWidget {
  final Task task;

  const _TaskWidget({Key key, this.task}) : super(key: key);

  @override
  _TaskWidgetState createState() {
    return new _TaskWidgetState();
  }
}

class _TaskWidgetState extends State<_TaskWidget> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(widget.task.text),
          trailing: widget.task.isComplete ? Icon(Icons.check) : Icon(Icons.radio_button_unchecked),
          onTap: (){
            setState(() {
              widget.task.isComplete = !widget.task.isComplete;
            });
          },
        ),
        Divider(),
      ],
    );
  }
}
