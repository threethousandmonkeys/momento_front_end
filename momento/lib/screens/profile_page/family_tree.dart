import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:momento/constants.dart';

class FamilyTree extends StatefulWidget {
  @override
  _FamilyTreeState createState() => _FamilyTreeState();
}

class _FamilyTreeState extends State<FamilyTree> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: PhotoView(
        backgroundDecoration: kBackgroundDecoration,
        imageProvider: AssetImage("assets/images/test_family_tree.jpg"),
      ),
    );
  }
}
