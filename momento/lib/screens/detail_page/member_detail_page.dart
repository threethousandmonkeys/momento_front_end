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
            CachedNetworkImage(
              imageUrl: member.photo,
              placeholder: (context, url) => SpinKitCircle(
                color: Colors.purple,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Text(member.firstName,
                    style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(member.description),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("Gender: ",
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(member.gender),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("Date of Birth: ",
                style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(member.birthday.toString().split(' ')[0]),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("Date of Death: ",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Text(member.deathday.toString().split(' ')[0]),
                )
              ],
            ),

            UglyButton(
              text: "Edit Your Profile",
              height: 10,
              onPressed: (){
                print("aha");
              },
            ),
          ],
        ),
      ),
    );
  }
}
