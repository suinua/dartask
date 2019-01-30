import 'dart:async';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

User loginUser;

class TaskGroupListBloc {
  final List<TaskGroup> _taskGroupList = <TaskGroup>[];

  final _taskGroupListRef =
      FirebaseDatabase.instance.reference().child('task_group_list');

  StreamController<List<TaskGroup>> _taskGroupListController =
      StreamController<List<TaskGroup>>();

  StreamSink<List<TaskGroup>> get _set => _taskGroupListController.sink;

  Stream<List<TaskGroup>> get outList => _taskGroupListController.stream;

  StreamController<TaskGroup> _addController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get addGroup => _addController.sink;

  StreamController<TaskGroup> _updateController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get updateGroup => _updateController.sink;

  StreamController<TaskGroup> _removeController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get removeGroup => _removeController.sink;

  TaskGroupListBloc() {
    _addController.stream.listen(_addGroupHandleLogic);
    _updateController.stream.listen(_updateGroupHandleLogic);
    _removeController.stream.listen(_removeGroupHandleLogic);

    _taskGroupListRef.onChildAdded.listen((event) {
      print('add task group:${event.snapshot.value}');
      _taskGroupList.add(TaskGroup(
        event.snapshot.value['title'],
        owner: loginUser,
        key: event.snapshot.key,
      ));
      _set.add(_taskGroupList);
    });

    _taskGroupListRef.onChildRemoved.listen((event) {
      print('remove task group:${event.snapshot.value}');
      _taskGroupList.remove(TaskGroup(
        event.snapshot.value['title'],
        owner: loginUser,
        key: event.snapshot.key,
      ));
      _set.add(_taskGroupList);
    });
  }

  void _addGroupHandleLogic(data) {
    _taskGroupListRef.push().set(data.asMap());
  }

  void _updateGroupHandleLogic(data) {
    _taskGroupListRef.child(data.key).update(data.asMap());
  }

  void _removeGroupHandleLogic(data) {
    _taskGroupListRef.child(data.key).remove();
  }

  void dispose() async {
    await _taskGroupListController.close();
    await _addController.close();
    await _updateController.close();
    await _removeController.close();
  }
}
