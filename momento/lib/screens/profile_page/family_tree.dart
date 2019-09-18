import 'package:flutter/material.dart';
import 'package:momento/screens/add_new_page/add_new_member_page.dart';

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
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewMemberPage()));
        },
        child: Icon(
          Icons.people_outline,
          size: 100,
        ),
      ),
    );
  }
}
