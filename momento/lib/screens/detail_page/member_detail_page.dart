import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/screens/components/entry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:momento/screens/detail_page/detail_page.dart';
import 'package:momento/screens/form_pages/update_member_page.dart';
import 'package:momento/services/dialogs.dart';
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
  final _keyLoader = GlobalKey<State>();
  final _memberRepository = MemberRepository();

  @override
  void initState() {
    currentMember = widget.member;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2.7;
    return DetailPage(
      edit: () async {
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
      delete: () async {
        Dialogs.showLoadingDialog(context, _keyLoader);
        await _memberRepository.deleteMember(
          Provider.of<ProfileBloc>(context).family,
          currentMember,
        );
        Provider.of<ProfileBloc>(context).deleteMember(currentMember.id);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.pop(context);
      },
      content: [
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
            padding: const EdgeInsets.only(bottom: 0),
            child: AutoSizeText(
              "${currentMember.firstName} ${currentMember.lastName}",
              minFontSize: 40,
              style: TextStyle(
                color: kDarkRedMoranti,
                fontWeight: FontWeight.bold,
                fontFamily: "Anton",
              ),
            ),
          ),
        ),
        Center(
          child: AutoSizeText(
            "${currentMember.birthday.toString().split(' ')[0]} to ${currentMember.deathday != null ? currentMember.deathday.toString().split(' ')[0] : "Present"}",
            minFontSize: 20,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width - width) * 0.25,
          ),
          child: Column(
            children: <Widget>[
              Entry(
                title: "Gender",
                content: currentMember.gender,
              ),
              Entry(
                title: "Description",
                content: currentMember.description,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
