import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/detail_page/member_detail_page.dart';
import 'package:momento/screens/form_pages//add_new_member_page.dart';
import 'package:provider/provider.dart';

const kCardColor = Color(0xFFFBF0E9);

/// UI part for stemma page
class Stemma extends StatelessWidget {
  List<Widget> _createFamilyMemberCards(List<Member> members, double width, BuildContext context) {
    List<Widget> output = [];
    if (members.isNotEmpty) {
      members.sort((a, b) => a.birthday.compareTo(b.birthday));
    }
    for (int i = 0; i < members.length; i++) {
      output.add(
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberDetailPage(
                  members[i],
                ),
              ),
            );
          },
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              color: kCardColor,
              elevation: 2.5,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                height: width * kGoldenRatio * kGoldenRatio * kGoldenRatio,
                child: Row(
                  children: <Widget>[
                    ExtendedImage.network(
                      members[i].thumbnail ?? members[i].photo,
                      cache: true,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      width: 2,
                      color: kDarkRedMorandi,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              members[i].firstName + " " + members[i].lastName,
                              maxLines: 1,
                              minFontSize: 27,
                              overflowReplacement: Text(
                                "${members[i].firstName[0].toUpperCase()}. ${members[i].lastName[0].toUpperCase()}.",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontFamily: "Lobster",
                                  color: kMainTextColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Lobster",
                                color: kMainTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      bottom: false,
      child: StreamBuilder<List<Member>>(
        stream: Provider.of<ProfileBloc>(context).getMembers,
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView(
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              key: const PageStorageKey<String>("members"),
              children: _createFamilyMemberCards(snapshot.data, width, context)
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
                        Provider.of<ProfileBloc>(context).addMember(newMember);
                      }
                    },
                    child: Icon(
                      Icons.add,
                      size: 60,
                      color: kMainTextColor,
                    ),
                  ),
                ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
