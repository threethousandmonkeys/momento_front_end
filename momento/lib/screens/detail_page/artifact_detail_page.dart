import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                padding: const EdgeInsets.all(0),
                child: Text(artefact.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text("Description: " + artefact.description),
            Text(artefact.currentOwnerId.toString().split(' ')[0]),
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
