import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/widget_colors.dart';
import 'package:flutter/material.dart';

class CreateTaskGroupPage extends StatefulWidget {
  @override
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
                      Navigator.pop(context);
                      bloc.addGroup.add(TaskGroup(_titleText));
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
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: Text(
                      'New Task Group',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
              ],
            ),

            Padding(padding: const EdgeInsets.only(bottom: 50)),

            Expanded(
              child: Theme(
                data: ThemeData(
                  primaryColor: WidgetColors.border,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    fillColor: WidgetColors.border,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _titleText = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
