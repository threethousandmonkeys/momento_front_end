import 'package:flutter/material.dart';

class Entry extends StatelessWidget {
  final String title;
  final String content;
  Entry({this.title, this.content});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title + ": ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        Text(content,
          style: TextStyle(
              fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}