import 'package:flutter/material.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/add_new_page/add_new_member_page.dart';

/// FamilyTree: the widget to build family tree
class FamilyTree extends StatefulWidget {
  final Family family;
  final List<Member> members;
  FamilyTree(this.family, this.members);
  @override
  _FamilyTreeState createState() => _FamilyTreeState();
}

/// _FamilyTreeState: the state control of family tree feature
/// (not fully implement)
class _FamilyTreeState extends State<FamilyTree> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Column(
            children: widget.members.map((member) {
              return Text(
                member.firstName,
                style: TextStyle(fontSize: 30),
              );
            }).toList(),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewMemberPage(widget.family, widget.members),
                ),
              );
            },
            child: Icon(
              Icons.add_circle_outline,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
