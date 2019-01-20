import 'dart:async';
import 'package:dartask/model/task_group.dart';



class TaskGroupListBloc {
  List<TaskGroup> _taskGroupList;

  StreamController<List<TaskGroup>> _taskGroupListController = StreamController<List<TaskGroup>>();
  StreamSink<List<TaskGroup>> get _inAdd => _taskGroupListController.sink;
  Stream<List<TaskGroup>> get outList => _taskGroupListController.stream;

  StreamController<TaskGroup> _actionController = StreamController<TaskGroup>();
  StreamSink<TaskGroup> get increment => _actionController.sink;

  TaskGroupListBloc() {
    _taskGroupList = <TaskGroup>[];
    _actionController.stream.listen(_handleLogic);
  }

  void _handleLogic(data) {
    _taskGroupList.add(data);
    _inAdd.add(_taskGroupList);
  }

  void dispose() async {
    await _taskGroupListController.close();
    await _actionController.close();
  }
}