import 'package:dartask/bloc/task_group_list_bloc.dart';
import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/view/task_group_list_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(TaskGroupListBlocProvider(
  child: App(),
  bloc: TaskGroupListBloc(),
));

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dartask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskGroupsPage(),
    );
  }
}