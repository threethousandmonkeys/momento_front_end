import 'package:cloud_firestore/cloud_firestore.dart';

/// a model to represent family, which store the name and description and email
class Artefact {
  String id;
  String name;
  DateTime dateCreated;
  String originalOwnerId;
  String currentOwnerId;
  String description;

  Artefact({
    this.id,
    this.name,
    this.dateCreated,
    this.originalOwnerId,
    this.currentOwnerId,
    this.description,
  });

  static Artefact parseArtefact(String artefactId, Map<String, dynamic> jsonArtefact) {
    return Artefact(
      id: artefactId,
      name: jsonArtefact["name"],
      dateCreated: DateTime.fromMillisecondsSinceEpoch(jsonArtefact["date_created"].seconds * 1000),
      originalOwnerId: jsonArtefact["original_owner"],
      currentOwnerId: jsonArtefact["current_owner"],
      description: jsonArtefact["description"],
    );
  }

  Map<String, dynamic> serialize() {
    return {
      "name": this.name,
      "date_created": dateCreated != null
          ? Timestamp((dateCreated.millisecondsSinceEpoch * 0.001).toInt(), 0)
          : null,
      "original_owner": this.originalOwnerId,
      "current_owner": this.currentOwnerId,
      "description": this.description,
    };
  }
}
