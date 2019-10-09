import 'package:flutter/material.dart';
import 'package:momento/screens/components/entry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

import '../../constants.dart';
import '../../models/member.dart';
import '../components/ugly_button.dart';

class MemberDetailPage extends StatelessWidget {
  final Member member;
  MemberDetailPage(this.member);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 50.0, right: 50, top: 200),
                child: CircularProfileAvatar(
                  member.photo,
                  radius: MediaQuery.of(context).size.width / 3,
                  borderWidth: 15,
                  borderColor: Color(0x30FFFFFF),
                  cacheImage: true,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    member.firstName,
                    style: TextStyle(
                      color: Color(0xFF421910),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Entry(
                title: "Description",
                content: member.description,
              ),
              Entry(
                title: "Gender",
                content: member.gender,
              ),
              Entry(
                title: "Date of Birth",
                content: member.birthday.toString().split(' ')[0],
              ),
              Entry(
                title: "Date of Death",
                content: member.deathday.toString().split(' ')[0],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: UglyButton(
                  text: "Edit Your Profile",
                  height: 10,
                  onPressed: () {
                    print("aha");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
