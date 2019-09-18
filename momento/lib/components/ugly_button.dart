import 'package:flutter/material.dart';
import 'package:momento/constants.dart';

/// Build for the button components used later.
class UglyButton extends StatelessWidget {
  /// the text showing on the button
  final String text;

  /// the height of this widget
  final double height;

  /// effect if the button pressed once
  final Function onPressed;

  /// applying rotation of the widget
  final Matrix4 transform;
  UglyButton({
    this.text,
    this.height,
    this.onPressed,
    this.transform,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      transform: transform,
      child: MaterialButton(
        height: height,
        color: Color(0xFF9E8C81),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: Text(
            text,
            style: kButtonTextStyle,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
