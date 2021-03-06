import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final double size;

  const PageTitle({Key key, @required this.title, @required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey,
            height: 1.5,
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
