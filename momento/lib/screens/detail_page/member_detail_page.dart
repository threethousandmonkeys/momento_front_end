import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: member.photo,
                placeholder: (context, url) => SpinKitCircle(
                  color: Colors.purple,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(member.firstName,
                    style: TextStyle(
                  color: Colors.black,
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
                onPressed: (){
                  print("aha");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Entry extends StatelessWidget {
  final String title;
  final String content;
  Entry({this.title, this.content});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title + ": ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
        ),
        Text(content,
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ],
    );
  }
}
