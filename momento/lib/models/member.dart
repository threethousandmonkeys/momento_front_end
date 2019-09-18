import 'package:cloud_firestore/cloud_firestore.dart';

/// a model to represent family, which store the name and description and email
class Member {
  String name;
  String gender;
  String address;
  DateTime birthday;

  Member({
    this.name,
    this.gender,
    this.address,
    this.birthday
  });
}

Future<Member> parseMember(String uid) async {
}
