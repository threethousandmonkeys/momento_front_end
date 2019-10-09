import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/detail_page/member_detail_page.dart';
import 'package:momento/screens/form_pages//add_new_member_page.dart';
import 'package:momento/screens/components/loading_page.dart';
import 'package:momento/screens/form_pages/update_member_page.dart';
import 'package:provider/provider.dart';

/// FamilyTree: the widget to build family tree
class FamilyTree extends StatefulWidget {
  @override
  _FamilyTreeState createState() => _FamilyTreeState();
}

/// _FamilyTreeState: the state control of family tree feature
/// (not fully implement)
class _FamilyTreeState extends State<FamilyTree> {
  ProfileBloc _bloc;

  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of<ProfileBloc>(context);
    return StreamBuilder<List<Member>>(
        stream: _bloc.getMembers,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Column(
              children: <Widget>[
                Column(
                  children: snapshot.data.map((member) {
                    return GestureDetector(
                      onTap: () async {
                        final updatedMember = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MemberDetailPage(),
                          ),
                        );
                        if (updatedMember != null) {
                          _bloc.updateMember(updatedMember);
                        }
                      },
                      child: Text(
                        member.firstName,
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  }).toList(),
                ),
                GestureDetector(
                  onTap: () async {
                    final newMember = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewMemberPage(_bloc.family, snapshot.data),
                      ),
                    );
                    if (newMember != null) {
                      _bloc.addMember(newMember);
                    }
                  },
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 50,
                  ),
                ),
              ],
            );
          } else {
            return LoadingPage();
          }
        });
  }
}
