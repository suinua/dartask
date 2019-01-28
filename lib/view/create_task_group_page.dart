import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/page_title_widget.dart';
import 'package:dartask/widget_colors.dart';
import 'package:flutter/material.dart';

class CreateTaskGroupPage extends StatefulWidget {
  @override
  _CreateTaskGroupPageState createState() => _CreateTaskGroupPageState();
}

class _CreateTaskGroupPageState extends State<CreateTaskGroupPage> {
  String titleText = '';

  bool _canSave() => titleText.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bloc = TaskGroupListBlocProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white30,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        actions: <Widget>[
          Center(
            child: RaisedButton(
              color: WidgetColors.button,
              onPressed: _canSave()
                  ? () {
                      bloc.addGroup.add(TaskGroup(titleText));
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('save'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            PageTitle(title: 'New Task Group', size: 30),
            Padding(padding: const EdgeInsets.only(bottom: 50)),
            Theme(
              data: ThemeData(primaryColor: WidgetColors.border),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  fillColor: WidgetColors.border,
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    titleText = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
