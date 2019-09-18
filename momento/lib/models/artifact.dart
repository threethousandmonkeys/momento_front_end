import 'package:cloud_firestore/cloud_firestore.dart';
import 'member.dart';

/// a model to represent family, which store the name and description and email
class Artifact {
  String artifactName;
  String originalOwner;
  List<Member> passingHistory;

  Artifact({
    this.artifactName,
    this.originalOwner,
    this.passingHistory
  });
}

Future<Artifact> parseArtifact(String uid) async {
}
