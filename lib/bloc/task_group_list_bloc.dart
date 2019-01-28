import 'dart:async';
import 'package:dartask/model/task_group.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskGroupListBloc {
  List<TaskGroup> _taskGroupList = [];
  final _mainReference = FirebaseDatabase.instance.reference().child('task_group_list');

  StreamController<List<TaskGroup>> _taskGroupListController =
      StreamController<List<TaskGroup>>();

  StreamSink<List<TaskGroup>> get _inAdd => _taskGroupListController.sink;

  Stream<List<TaskGroup>> get outList => _taskGroupListController.stream;

  StreamController<TaskGroup> _addController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get addGroup => _addController.sink;

  StreamController<TaskGroup> _removeController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get removeGroup => _removeController.sink;

  TaskGroupListBloc() {
    _addController.stream.listen(_addGroupHandleLogic);
    _removeController.stream.listen(_removeGroupHandleLogic);
  }

  void _addGroupHandleLogic(data) {
    _mainReference.set(data.asMap());
    _taskGroupList.add(data);
    _inAdd.add(_taskGroupList);
  }

  void _removeGroupHandleLogic(data) {
    _taskGroupList.remove(data);
    _inAdd.add(_taskGroupList);
  }

  void dispose() async {
    await _taskGroupListController.close();
    await _addController.close();
    await _removeController.close();
  }
}
