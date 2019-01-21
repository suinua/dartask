import 'package:dartask/bloc/task_group_list_bloc.dart';
import 'package:flutter/cupertino.dart';

class TaskGroupListBlocProvider extends InheritedWidget {

  final TaskGroupListBloc bloc;

  TaskGroupListBlocProvider({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  static TaskGroupListBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(TaskGroupListBlocProvider)
    as TaskGroupListBlocProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(TaskGroupListBlocProvider oldWidget) =>
      bloc != oldWidget.bloc;
}