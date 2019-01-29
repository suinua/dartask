import 'dart:async';

import 'package:dartask/bloc/task_group_list_bloc.dart';
import 'package:dartask/bloc/task_group_list_bloc_provider.dart';
import 'package:dartask/view/widgets/floating_button_widget.dart';
import 'package:dartask/model/user.dart';
import 'package:dartask/view/widgets/page_title_widget.dart';
import 'package:dartask/view/create_task_group_page.dart';
import 'package:dartask/view/task_group_list_page.dart';
import 'package:dartask/widget_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final _auth = FirebaseAuth.instance;
  User _user;

  final _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  void setUser(User user) {
    setState(() {
      _user = user;
      loginUser = user;
    });
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return user;
  }

  @override
  void initState() {
    super.initState();
    _handleGoogleSignIn().then((user) {
      setUser(User(name: user.displayName, email: user.email));
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: _user == null
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
      bottomNavigationBar: _user == null ? null : TaskGroupListBottom(),
      body: _user != null ? TaskGroupListPage(user: _user) : _authPage(),
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
            _handleGoogleSignIn().then((user) {
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
