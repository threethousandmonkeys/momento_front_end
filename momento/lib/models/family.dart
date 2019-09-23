/// a model to represent family, which store the name and description and email
class Family {
  String id;
  String name;
  String description;
  String email;
  List<String> members;

  Family({
    this.id,
    this.name,
    this.description,
    this.email,
    this.members,
  });

  static Family parseFamily(String familyId, Map<String, dynamic> jsonFamily) {
    List<String> members = [];
    for (int i = 0; i < jsonFamily["members"].length; i++) {
      members.add(jsonFamily["members"][i]);
    }
    return Family(
      id: familyId,
      name: jsonFamily["name"],
      description: jsonFamily["description"],
      email: jsonFamily["email"],
      members: members,
    );
  }

  Map<String, dynamic> serialize() {
    return {
      "name": this.name,
      "description": this.description,
      "email": this.email,
      "members": this.members,
    };
  }
}
