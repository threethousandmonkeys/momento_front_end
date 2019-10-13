import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/detail_page/member_detail_page.dart';
import 'package:momento/screens/form_pages//add_new_member_page.dart';
import 'package:provider/provider.dart';

/// Stemma: the widget to build family members list
class Stemma extends StatefulWidget {
  @override
  _StemmaState createState() => _StemmaState();
}

/// _StemmaState: the state control of family tree feature
class _StemmaState extends State<Stemma> with AutomaticKeepAliveClientMixin {
  ProfileBloc _bloc;

  List<GestureDetector> _createFamilyMemberCard(List<Member> members, double width) {
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
                      child: CachedNetworkImage(
                        imageUrl: members[i].thumbnail ?? members[i].photo,
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
    super.build(context);

    double width = MediaQuery.of(context).size.width;
    if (_bloc == null) {
      _bloc = Provider.of<ProfileBloc>(context);
    }
    return StreamBuilder<List<Member>>(
      stream: _bloc.getMembers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return ListView(
            key: PageStorageKey<String>("members"),
            padding: EdgeInsets.all(0.0),
            children: _createFamilyMemberCard(snapshot.data, width)
              ..add(
                GestureDetector(
                  onTap: () async {
                    final newMember = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewMemberPage(snapshot.data),
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
              ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
