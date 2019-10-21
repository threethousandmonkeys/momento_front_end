import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/screens/components/entry.dart';
import 'package:momento/screens/detail_page/detail_page.dart';
import 'package:momento/screens/form_pages/update_artefact_page.dart';
import 'package:momento/screens/components/viewable_image.dart';
import 'package:momento/services/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:momento/constants.dart';

/// UI part for artifact detail pages
class ArtefactDetailPage extends StatefulWidget {
  final Artefact artefact;
  ArtefactDetailPage(this.artefact);

  @override
  _ArtefactDetailPageState createState() => _ArtefactDetailPageState();
}

class _ArtefactDetailPageState extends State<ArtefactDetailPage> {
  final _keyLoader = GlobalKey<State>();
  final _artefactRepository = ArtefactRepository();
  Artefact currentArtefact;
  @override
  void initState() {
    currentArtefact = widget.artefact;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2.7;
    return DetailPage(
      edit: () async {
        final updatedArtefact = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateArtefactPage(
              currentArtefact,
              Provider.of<ProfileBloc>(context).getLatestMembers,
            ),
          ),
        );
        if (updatedArtefact != null) {
          currentArtefact = updatedArtefact;
          Provider.of<ProfileBloc>(context).updateArtefact(updatedArtefact);
        }
      },
      delete: () async {
        Dialogs.showLoadingDialog(context, _keyLoader);
        await _artefactRepository.deleteArtefact(
          Provider.of<ProfileBloc>(context).family,
          currentArtefact,
        );
        Provider.of<ProfileBloc>(context).deleteArtefact(currentArtefact.id);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.pop(context);
      },
      content: <Widget>[
        ViewableImage(currentArtefact.photo),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              currentArtefact.name,
              maxFontSize: 40,
              style: TextStyle(
                color: kHeaderColor,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width - width) * 0.15,
          ),
          child: Column(
            children: <Widget>[
              Entry(
                title: "Description",
                content: currentArtefact.description,
              ),
              Entry(
                title: "Original Owner",
                content: getMemberNameById(currentArtefact.originalOwnerId),
              ),
              Entry(
                title: "Current Owner",
                content: getMemberNameById(currentArtefact.currentOwnerId),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Gets the first and last name of a member, based on its user id
  String getMemberNameById(String userId) {
    Member member = Provider.of<ProfileBloc>(context).getMemberByUserId(userId);
    if (member != null) {
      return member.firstName + " " + member.lastName;
    } else {
      return "Unknown";
    }
  }
}
