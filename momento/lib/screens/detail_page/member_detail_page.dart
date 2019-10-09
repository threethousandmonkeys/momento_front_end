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
    double width = MediaQuery.of(context).size.width / 2.7;
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProfileAvatar(
                    member.photo,
                    radius: width,
                    borderWidth: 15,
                    borderColor: Color(0x20BFBFBF),
                    cacheImage: true,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    member.firstName,
                    style: TextStyle(
                      color: kDarkRedMoranti,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width - width) * 0.25,
                ),
                child: Column(
                  children: <Widget>[
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: (MediaQuery.of(context).size.width - width) * 0.25,
                ),
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
