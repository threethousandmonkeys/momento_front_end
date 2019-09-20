import 'package:cloud_firestore/cloud_firestore.dart';
import 'member.dart';

/// a model to represent family, which store the name and description and email
class Artefact {
  String artifactName;
  String originalOwner;
  List<Member> passingHistory;

  Artefact({this.artifactName, this.originalOwner, this.passingHistory});
}

Future<Artefact> parseArtifact(String uid) async {}
