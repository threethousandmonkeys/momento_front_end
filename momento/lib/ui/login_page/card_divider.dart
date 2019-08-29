import 'package:flutter/material.dart';

class CardDivider extends StatelessWidget {
  CardDivider({this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1.0,
      color: Colors.grey[400],
    );
  }
}