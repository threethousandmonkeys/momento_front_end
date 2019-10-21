import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/screens/components/entry.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:momento/screens/detail_page/detail_page.dart';
import 'package:momento/screens/form_pages/update_member_page.dart';
import 'package:momento/services/dialogs.dart';
import 'package:provider/provider.dart';
import '../../models/member.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:expandable_card/expandable_card.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'artifact_detail_page.dart';

/// UI part for member detail pages
class MemberDetailPage extends StatefulWidget {
  final Member member;
  MemberDetailPage(this.member);

  @override
  _MemberDetailPageState createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  Member currentMember;
  List<Artefact> artefacts = [];
  final _keyLoader = GlobalKey<State>();
  final _memberRepository = MemberRepository();

  @override
  void initState() {
    currentMember = widget.member;
    super.initState();
  }

  Widget _buildPage(double width) {
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
            top: MediaQuery.of(context).size.height * 0.025,
            bottom: MediaQuery.of(context).size.height * 0.020,
          ),
          child: Align(
            alignment: Alignment.center,
            child: CircularProfileAvatar(
              currentMember.photo,
              radius: width,
              borderWidth: 15,
              borderColor: Color(0x40BFBFBF),
              cacheImage: true,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              "${currentMember.firstName} ${currentMember.lastName}",
              minFontSize: 40,
              maxLines: 1,
              overflowReplacement: Text(
                "${currentMember.firstName[0].toUpperCase()}. ${currentMember.lastName[0].toUpperCase()}.",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Anton",
                ),
                textAlign: TextAlign.center,
              ),
              style: TextStyle(
                color: kDarkRedMoranti,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: AutoSizeText(
                "${currentMember.birthday.toString().split(' ')[0]} - ${currentMember.deathday != null ? currentMember.deathday.toString().split(' ')[0] : "present"}",
                minFontSize: 20,
                style: TextStyle(
                  color: kMainTextColor,
                )),
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width - width) * 0.15),
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2.7;
    artefacts = Provider.of<ProfileBloc>(context).getRelatedArtefact(widget.member.id);
    return Scaffold(
      body: artefacts.isEmpty
          ? _buildPage(width)
          : ExpandableCardPage(
              page: _buildPage(width),
              expandableCard: ExpandableCard(
                backgroundColor: Color(0xAAFBF0E9),
                hasRoundedCorners: true,
                hasHandle: false,
                padding: const EdgeInsets.all(10.0),
                maxHeight: MediaQuery.of(context).size.height * kGoldenRatio,
                minHeight: MediaQuery.of(context).size.height * 0.1,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Related Artefacts",
                                  style: TextStyle(
                                    fontFamily: "Anton",
                                    color: kDarkRedMoranti,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.width * 0.8 - 10,
                              width: MediaQuery.of(context).size.width,
                              child: Swiper(
                                loop: false,
                                controller: SwiperController(),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ArtefactDetailPage(artefacts[index]),
                                        ),
                                      );
                                    },
                                    child: new Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ExtendedImage.network(
                                          artefacts[index].thumbnail ?? artefacts[index].photo,
                                          fit: BoxFit.fill,
                                          cache: true,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: artefacts.length,
                                viewportFraction: 0.8,
                                scale: 0.9,
                                pagination: new SwiperPagination(),
                              ),
                            ),
                          ],
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
