import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/screens/components/entry.dart';
import 'package:momento/screens/form_pages/update_artefact_page.dart';
import 'package:momento/screens/components/viewable_image.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/artefact.dart';
import '../components/ugly_button.dart';

class ArtefactDetailPage extends StatefulWidget {
  final Artefact artefact;
  ArtefactDetailPage(this.artefact);

  @override
  _ArtefactDetailPageState createState() => _ArtefactDetailPageState();
}

class _ArtefactDetailPageState extends State<ArtefactDetailPage> {
  Artefact currentArtefact;
  @override
  void initState() {
    currentArtefact = widget.artefact;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            ViewableImage(currentArtefact.photo),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  currentArtefact.name,
                  style: TextStyle(
                    color: Color(0xFF6B5152),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
              child: Column(
                children: <Widget>[
                  Entry(
                    title: "Description",
                    content: currentArtefact.description,
                  ),
                  Entry(
                    title: "Original Owner",
                    content: currentArtefact.originalOwnerId,
                  ),
                  Entry(
                    title: "Current Owner",
                    content: currentArtefact.currentOwnerId,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: UglyButton(
                text: "Edit Your Profile",
                height: 10,
                onPressed: () async {
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
