import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class Task {
  final String parentKey;
  final String key;
  DatabaseReference _parentGroupRef = FirebaseDatabase.instance.reference();

  String text;
  bool isComplete;
  Widget _checkBox;

  Task(this.text, {this.isComplete = false, this.parentKey, this.key}) {
    _checkBox = Icon(Icons.radio_button_unchecked);
    if (this.key != null) {
      _parentGroupRef =
          _parentGroupRef.child('task_group_list').child(this.parentKey);
    }
  }

  Future<void> remove() {
    return _parentGroupRef.child('task_list').child(this.key).remove();
  }

  Future<void> update() {
    return _parentGroupRef
        .child('task_list')
        .child(this.key)
        .update(this.asMap());
  }

  bool operator ==(o) => o is Task && o.key == key;

  Map<String, dynamic> asMap() => {
        'text': this.text,
        'isComplete': this.isComplete,
      };

  Widget asWidget({@required Function update}) =>
      _TaskWidget(task: this, update: update);
}

enum _DeleteConformDialogAction {
  Ok,
  Cancel,
}

class _DeleteConformDialog extends StatelessWidget {
  final String taskText;

  _DeleteConformDialog({Key key, this.taskText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(taskText),
      content: Text('タスクを削除しますか？'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, _DeleteConformDialogAction.Cancel);
            },
            child: Text('キャンセル')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, _DeleteConformDialogAction.Ok);
            },
            child: Text('削除'))
      ],
    );
  }
}

class _TaskWidget extends StatefulWidget {
  final Task task;
  final Function update;

  _TaskWidget({Key key, this.task, this.update}) : super(key: key);

  @override
  _TaskWidgetState createState() {
    return _TaskWidgetState();
  }
}

class _TaskWidgetState extends State<_TaskWidget> {
  bool canTap = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Slidable(
          delegate: SlidableDrawerDelegate(),
          secondaryActions: <Widget>[
            Container(
              child: IconSlideAction(
                caption: 'Remove',
                color: Colors.red,
                icon: Icons.restore_from_trash,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _DeleteConformDialog(taskText: widget.task.text);
                    },
                  ).then((value) {
                    if (value == _DeleteConformDialogAction.Ok) {
                      widget.task.remove().then((_) => widget.update());
                    }
                  });
                },
              ),
            ),
          ],
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
                      widget.task.update().then((_) {
                        canTap = true;
                        widget.update();
                      });
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
