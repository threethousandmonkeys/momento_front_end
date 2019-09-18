import 'package:flutter/material.dart';
import 'package:momento/constants.dart';

/// Build for the button components used later
class UglyButton extends StatelessWidget {
  final String text;
  final double height;
  final Function onPressed;
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
