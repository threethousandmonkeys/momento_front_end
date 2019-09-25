/// a model to represent family, which store the name and description and email
class Family {
  String id;
  String name;
  String description;
  String email;
  List<String> members;
  List<String> artefacts;
  List<String> events;
  int numPhotos;

  Family({
    this.id,
    this.name,
    this.description,
    this.email,
    this.members,
    this.artefacts,
    this.events,
    this.numPhotos,
  });

  static Family parseFamily(String familyId, Map<String, dynamic> jsonFamily) {
    return Family(
      id: familyId,
      name: jsonFamily["name"],
      description: jsonFamily["description"],
      email: jsonFamily["email"],
      members: List<String>.from(jsonFamily["members"]),
      artefacts: List<String>.from(jsonFamily["artefacts"]),
      events: List<String>.from(jsonFamily["events"]),
      numPhotos: jsonFamily["num_photos"],
    );
  }

  Map<String, dynamic> serialize() {
    return {
      "name": this.name,
      "description": this.description,
      "email": this.email,
      "members": this.members,
      "artefacts": this.artefacts,
      "events": this.events,
      "num_photos": this.numPhotos,
    };
  }
}
