import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:momento/constants.dart';

/// Build for the button components used later.
class UglyButton extends StatelessWidget {
  /// the text showing on the button
  final String text;

  /// the height of this widget
  final double height;

  /// effect if the button pressed once
  final Function onPressed;

  /// color of button
  final Color color;

  /// applying rotation of the widget
  final Matrix4 transform;
  UglyButton({
    this.text,
    this.height,
    this.onPressed,
    this.transform,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      transform: transform,
      child: PlatformButton(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: this.color,
        child: Text(
          text,
          style: kButtonTextStyle,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
