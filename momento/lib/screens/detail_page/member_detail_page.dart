import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/screens/components/entry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:momento/screens/form_pages/update_member_page.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/member.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// UI part for member detail pages
class MemberDetailPage extends StatefulWidget {
  final Member member;
  MemberDetailPage(this.member);

  @override
  _MemberDetailPageState createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  Member currentMember;

  @override
  void initState() {
    currentMember = widget.member;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2.7;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        leading: PlatformIconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kDarkRedMoranti,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        trailingActions: <Widget>[
          PlatformIconButton(
            icon: Icon(
              Icons.edit,
              color: kDarkRedMoranti,
            ),
            onPressed: () async {
              final updatedMember = await Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => UpdateMemberPage(
                    currentMember,
                    Provider.of<ProfileBloc>(context).getLatestMembers,
                  ),
                ),
              );
              if (updatedMember != null) {
                currentMember = updatedMember;
                Provider.of<ProfileBloc>(context).updateMember(updatedMember);
              }
            },
          ),
          PlatformIconButton(
            icon: Icon(
              Icons.delete,
              color: kDarkRedMoranti,
            ),
            onPressed: () async {
              showPlatformDialog(
                context: context,
                androidBarrierDismissible: false,
                builder: (_) => PlatformAlertDialog(
                  title: PlatformText('Delete Member?'),
                  actions: <Widget>[
                    PlatformDialogAction(
                      child: PlatformText("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    PlatformDialogAction(
                      child: PlatformText(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Align(
                alignment: Alignment.center,
                child: CircularProfileAvatar(
                  currentMember.photo,
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
                child: PlatformText(
                  "${currentMember.firstName} ${currentMember.lastName}",
                  style: TextStyle(
                    color: kDarkRedMoranti,
                    fontSize: 42,
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
                    content: currentMember.description,
                  ),
                  Entry(
                    title: "Gender",
                    content: currentMember.gender,
                  ),
                  Entry(
                    title: "Date of Birth",
                    content: currentMember.birthday.toString().split(' ')[0],
                  ),
                  Entry(
                    title: "Date of Death",
                    content: currentMember.deathday.toString().split(' ')[0],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
