import 'package:dartask/bloc/task_group_list_bloc.dart';
import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/auth.dart';
import 'package:dartask/view/widgets/floating_button_widget.dart';
import 'package:dartask/model/user.dart';
import 'package:dartask/view/widgets/page_title_widget.dart';
import 'package:dartask/view/pages/create_task_group_page.dart';
import 'package:dartask/view/pages/task_group_list_page.dart';
import 'package:dartask/view/widget_colors.dart';
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  void setUser(User user) {
    final bloc = TaskGroupListBlocProvider.of(context);
    bloc.setUser.add(user);
    setState(() {
      loginUser = user;
    });
  }

  @override
  void initState() {
    googleSignIn().then((user) {
      setUser(User(name: user.displayName, email: user.email));
    }).catchError((e) {
      print(e);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: loginUser == null
          ? null
          : FloatingButtonWidget(
              text: 'TaskGroup',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => CreateTaskGroupPage(),
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: loginUser == null ? null : TaskGroupListBottom(),
      body: loginUser == null ? _authPage() : TaskGroupListPage(),
    );
  }

  Widget _authPage() {
    return Column(
      children: <Widget>[
        PageTitle(title: 'Dartask', size: 40),
        Text('by flutter'),
        Padding(padding: const EdgeInsets.only(bottom: 50)),
        RaisedButton(
          onPressed: () {
            googleSignIn().then((user) {
              setUser(User(name: user.displayName, email: user.email));
            }).catchError((e) {
              print(e);
            });
          },
          child: Text('Google Account'),
          color: WidgetColors.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        )
      ],
    );
  }
}
