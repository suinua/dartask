import 'dart:async';
import 'package:dartask/auth.dart';
import 'package:dartask/model/task_group.dart';
import 'package:dartask/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class TaskGroupListBloc {
  final List<TaskGroup> _taskGroupList = <TaskGroup>[];

  StreamController<User> _userController = StreamController<User>();

  StreamSink<User> get setUser => _userController.sink;

  StreamController<List<TaskGroup>> _taskGroupListController =
      StreamController<List<TaskGroup>>();

  StreamSink<List<TaskGroup>> get _setList => _taskGroupListController.sink;

  Stream<List<TaskGroup>> get outList => _taskGroupListController.stream;

  StreamController<TaskGroup> _addController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get addGroup => _addController.sink;

  StreamController<TaskGroup> _updateController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get updateGroup => _updateController.sink;

  StreamController<TaskGroup> _removeController = StreamController<TaskGroup>();

  StreamSink<TaskGroup> get removeGroup => _removeController.sink;

  TaskGroupListBloc() {
    _userController.stream.listen(_setDatabaseHandles);
  }

  void _setDatabaseHandles(e) {
    _FirebaseTaskGroupList _firebaseTaskGroupList =
        _FirebaseTaskGroupList(onChildAdded: add, onChildRemoved: remove);

    _addController.stream.listen(_firebaseTaskGroupList.add);
    _updateController.stream.listen(_firebaseTaskGroupList.update);
    _removeController.stream.listen(_firebaseTaskGroupList.remove);
  }

  void add(event) {
    print('add task group:${event.snapshot.value}');
    Map owner = event.snapshot.value['owner'];
    if (loginUser.email == owner['email']) {
      _taskGroupList.add(TaskGroup(
        event.snapshot.value['title'],
        owner: User(name: owner['name'], email: owner['email']),
        key: event.snapshot.key,
      ));
      _setList.add(_taskGroupList);
    }
  }

  void remove(event) {
    print('remove task group:${event.snapshot.value}');
    Map owner = event.snapshot.value['owner'];
    _taskGroupList.remove(TaskGroup(
      event.snapshot.value['title'],
      owner: User(name: owner['name'], email: owner['email']),
      key: event.snapshot.key,
    ));
    _setList.add(_taskGroupList);
  }

  void dispose() async {
    await _userController.close();

    await _taskGroupListController.close();
    await _addController.close();
    await _updateController.close();
    await _removeController.close();
  }
}

class _FirebaseTaskGroupList {
  DatabaseReference _taskGroupListRef;

  final Function(dynamic) onChildAdded;
  final Function(dynamic) onChildRemoved;

  _FirebaseTaskGroupList({this.onChildAdded, this.onChildRemoved}) {
    _taskGroupListRef = FirebaseDatabase.instance.reference().child('task_group_list')
      ..orderByChild('owner').equalTo(loginUser.email);

    _taskGroupListRef.onChildAdded.listen(onChildAdded);
    _taskGroupListRef.onChildRemoved.listen(onChildRemoved);
  }

  void remove(TaskGroup data) {
    _taskGroupListRef.child(data.key).remove();
  }

  void add(TaskGroup data) {
    _taskGroupListRef.push().set(data.asMap());
  }

  void update(TaskGroup data) {
    _taskGroupListRef.child(data.key).update(data.asMap());
  }
}
