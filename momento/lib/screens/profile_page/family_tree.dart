import 'package:flutter/material.dart';
import 'package:momento/bloc/family_tree_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/add_new_page/add_new_member_page.dart';

/// FamilyTree: the widget to build family tree
class FamilyTree extends StatefulWidget {
  final String familyId;
  final Family family;
  FamilyTree(this.familyId, this.family);
  @override
  _FamilyTreeState createState() => _FamilyTreeState();
}

/// _FamilyTreeState: the state control of family tree feature
/// (not fully implement)
class _FamilyTreeState extends State<FamilyTree> {
  FamilyTreeBloc _bloc;
  @override
  void initState() {
    _bloc = FamilyTreeBloc(widget.familyId, widget.family.members);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("building");
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          StreamBuilder<List<Member>>(
            stream: _bloc.members,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return _buildTree(snapshot.data);
              } else {
                return Center(
                  child: RefreshProgressIndicator(),
                );
              }
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewMemberPage(widget.familyId),
                ),
              );
            },
            child: Icon(
              Icons.people_outline,
              size: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTree(List<Member> members) {
    return Column(
      children: members.map((member) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            member.firstName,
            style: TextStyle(fontSize: 30),
          ),
        );
      }).toList(),
    );
  }
}
