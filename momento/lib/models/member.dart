import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { Male, Female, Other }

/// a model to represent family, which store the name and description and email
class Member {
  String name;
  Gender gender;
  DateTime birthday;
  DateTime deathday;
  String description;

  Member({
    this.name,
    this.gender,
    this.birthday,
    this.deathday,
    this.description,
  });
}

Future<Member> parseMember(String uid) async {}
