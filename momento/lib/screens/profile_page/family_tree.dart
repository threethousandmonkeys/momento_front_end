import 'package:flutter/material.dart';

class FamilyTree extends StatefulWidget {
  @override
  _FamilyTreeState createState() => _FamilyTreeState();
}

class _FamilyTreeState extends State<FamilyTree> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () {},
        child: Icon(
          Icons.people_outline,
          size: 100,
        ),
      ),
    );
  }
}
