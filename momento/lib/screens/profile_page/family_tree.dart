import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/detail_page/member_detail_page.dart';
import 'package:momento/screens/form_pages//add_new_member_page.dart';
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

  List<GestureDetector> _createFamilyMemberCard(
      List<Member> members, double width) {
    List<Color> colors = [Color(0xFFC9C0D3), Color(0xFFC1CBD7)];
    List<GestureDetector> output = [];
    if (members.isEmpty == false) {
      members.sort((a, b) => a.birthday.compareTo(b.birthday));
    }
    for (int i = 0; i < members.length; i++) {
      output.add(GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberDetailPage(members[i]),
            ),
          );
        },
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Card(
            color: colors[i % 2],
            child: Container(
              margin: EdgeInsets.all(10),
              height: width * kGoldenRatio * kGoldenRatio,
              child: Row(
                children: <Widget>[
                  FractionallySizedBox(
                    heightFactor: 1,
                    child: Container(
                      width: width * kGoldenRatio * kGoldenRatio,
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/loading_image.gif",
                        image: members[i].thumbnail ?? members[i].photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        members[i].firstName,
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    _bloc = Provider.of<ProfileBloc>(context);
    return StreamBuilder<List<Member>>(
      stream: _bloc.getMembers,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Column(
              children: _createFamilyMemberCard(snapshot.data, width) +
                  [
                    GestureDetector(
                      onTap: () async {
                        final newMember = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddNewMemberPage(snapshot.data),
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
                  ]);
        } else {
          return Text("Loading");
        }
      },
    );
  }
}
