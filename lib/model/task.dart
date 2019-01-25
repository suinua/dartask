import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Task {
  String text;
  Widget _checkBox;

  bool isComplete;

  Task(this.text, {this.isComplete = false})
      : _checkBox = Icon(Icons.radio_button_unchecked);

  Map<String, dynamic> asMap() => {
        'text': this.text,
        'isComplete': this.isComplete,
      };

  Widget asWidget({@required Function update}) =>
      _TaskWidget(task: this, update: update);
}

class _TaskWidget extends StatefulWidget {
  final Task task;
  final Function update;

  _TaskWidget({Key key, this.task, this.update}) : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<_TaskWidget> {
  bool canTap = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 1000),
          child: ListTile(
            title: Text(widget.task.text),
            trailing: widget.task._checkBox,
            onTap: canTap
                ? () {
                    canTap = false;

                    widget.task._checkBox = widget.task.isComplete
                        ? Icon(Icons.radio_button_unchecked)
                        : Icon(Icons.check);
                    widget.update();

                    Timer(Duration(milliseconds: 500), () {
                      widget.task.isComplete = !widget.task.isComplete;

                      canTap = true;
                      widget.update();
                    });
                  }
                : null,
          ),
        ),
        Divider(),
      ],
    );
  }
}
