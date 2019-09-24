/// a model to represent family, which store the name and description and email
class Family {
  String id;
  String name;
  String description;
  String email;
  List<String> members;
  List<String> artefacts;
  int numPhotos;

  Family({
    this.id,
    this.name,
    this.description,
    this.email,
    this.members,
    this.artefacts,
    this.numPhotos,
  });

  static Family parseFamily(String familyId, Map<String, dynamic> jsonFamily) {
    return Family(
      id: familyId,
      name: jsonFamily["name"],
      description: jsonFamily["description"],
      email: jsonFamily["email"],
      members: List<String>.from(jsonFamily["members"]),
      numPhotos: jsonFamily["num_photos"],
      artefacts: List<String>.from(jsonFamily["artefacts"]),
    );
  }

  Map<String, dynamic> serialize() {
    return {
      "name": this.name,
      "description": this.description,
      "email": this.email,
      "members": this.members,
      "num_photos": this.numPhotos,
      "artefacts": this.artefacts,
    };
  }
}
