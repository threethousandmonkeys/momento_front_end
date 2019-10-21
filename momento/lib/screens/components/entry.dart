import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:momento/constants.dart';

/// UI part for entry
class Entry extends StatelessWidget {
  final String title;
  final String content;
  Entry({this.title, this.content});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PlatformText(
          title + ": ",
          style: TextStyle(
            color: kMainTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: PlatformText(
            content ?? "",
            style: TextStyle(
              fontSize: 16,
              color: kMainTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
