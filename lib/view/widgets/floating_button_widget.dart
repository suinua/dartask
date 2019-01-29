import 'package:dartask/widget_colors.dart';
import 'package:flutter/material.dart';

class FloatingButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String text;

  const FloatingButtonWidget({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 4.0,
      backgroundColor: WidgetColors.button,
      icon: const Icon(Icons.add),
      label: Text(text),
      onPressed: onPressed,
    );
  }
}
