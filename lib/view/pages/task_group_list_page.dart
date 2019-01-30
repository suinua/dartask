import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/auth.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/view/widgets/page_title_widget.dart';
import 'package:dartask/view/widget_colors.dart';
import 'package:flutter/material.dart';

class TaskGroupListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = TaskGroupListBlocProvider.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          PageTitle(title: 'Dartask', size: 40),
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
          loginUser == null
              ? Container()
              : Container(
                  height: 150,
                  child: StreamBuilder<List<TaskGroup>>(
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

class TaskGroupListBottom extends StatelessWidget {
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //todo user menu
          IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        ],
      ),
    );
  }
}
