import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/view/create_task_group_page.dart';
import 'package:dartask/widget_colors.dart';
import 'package:flutter/material.dart';

class TaskGroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = TaskGroupListBlocProvider.of(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        backgroundColor: WidgetColors.button,
        icon: const Icon(Icons.add),
        label: Text('Task Group'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => CreateTaskGroupPage()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.menu), onPressed: () {}),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      'Task Group\'s',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      primaryColor: WidgetColors.border,
                    ),
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        fillColor: WidgetColors.border,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Card(
                  child: IconButton(
                      icon: const Icon(Icons.search), onPressed: () {}),
                )
              ],
            ),
            Container(
              height: 150,
              child: StreamBuilder(
                stream: bloc.outList,
                builder: (BuildContext context, snapshot) {
                  return _buildTaskGroupList(context, snapshot.data);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskGroupList(
      BuildContext context, List<TaskGroup> taskGroupList) {
    if (taskGroupList == null) {
      return ListView(children: <Widget>[]);
    }
    return ListView.builder(
      itemCount: taskGroupList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, int index) {
        return taskGroupList[index].asWidget(context);
      },
    );
  }
}
