import 'member.dart';

/// a model to represent family, which store the name and description and email
class Artefact {
  String artifactName;
  String originalOwner;
  List<Member> passingHistory;

  Artefact({this.artifactName, this.originalOwner, this.passingHistory});

  static Future<Null> parseArtifact(String uid) async {}
}
