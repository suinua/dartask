import 'package:dartask/bloc/task_group_list_bloc.dart';
import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/view/create_task_group_page.dart';
import 'package:flutter/material.dart';

class TaskGroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = TaskGroupListBlocProvider.of(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Task Group',
            style: TextStyle(fontSize: 50),
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
