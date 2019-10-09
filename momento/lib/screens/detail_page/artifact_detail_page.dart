import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momento/screens/components/entry.dart';

import '../../constants.dart';
import '../../models/artefact.dart';
import '../components/ugly_button.dart';

class ArtefactDetailPage extends StatelessWidget {

  final Artefact artefact;
  ArtefactDetailPage(this.artefact);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: artefact.photo,
              placeholder: (context, url) => SpinKitCircle(
                color: Colors.purple,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(artefact.name,
                  style: TextStyle(
                    color: Colors.black,
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
                    content: artefact.description,
                  ),

                  Entry(
                    title: "Original Owner",
                    content: artefact.originalOwnerId,
                  ),

                  Entry(
                    title: "Current Owner",
                    content: artefact.currentOwnerId,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
