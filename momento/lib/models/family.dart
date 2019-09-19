/// a model to represent family, which store the name and description and email
class Family {
  String name;
  String description;
  String email;

  Family({
    this.name,
    this.description,
    this.email,
  });

  static Family parseFamily(Map<String, dynamic> jsonFamily) {
    return Family(
      name: jsonFamily["name"],
      description: jsonFamily["description"],
      email: jsonFamily["email"],
    );
  }

  Map<String, dynamic> serialize() {
    return {
      "name": this.name,
      "description": this.description,
      "email": this.email,
    };
  }
}
