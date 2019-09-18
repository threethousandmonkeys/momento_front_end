import 'package:cloud_firestore/cloud_firestore.dart';

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
}

Future<Family> parseFamily(String uid) async {
  Firestore _firestore = Firestore.instance;
  Family family;
  await _firestore
      .collection("family")
      .document(uid)
      .get()
      .then((DocumentSnapshot ds) {
    family = Family(
      name: ds.data["name"],
      description: ds.data["description"],
      email: ds.data["email"],
    );
  });
  return family;
}
