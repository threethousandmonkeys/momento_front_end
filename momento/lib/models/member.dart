import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { Male, Female, Other }

/// a model to represent family, which store the name and description and email
class Member {
  String id;
  String firstName;
  String middleName;
  String gender;
  DateTime birthday;
  DateTime deathday;
  String fatherId;
  String motherId;
  String description;

  Member({
    this.id,
    this.firstName,
    this.middleName,
    this.gender,
    this.birthday,
    this.deathday,
    this.fatherId,
    this.motherId,
    this.description,
  });

  static Member parseMember(String memberId, Map<String, dynamic> jsonMember) {
    return Member(
      id: memberId,
      firstName: jsonMember["firstName"],
      middleName: jsonMember["middleName"],
      gender: jsonMember["gender"],
      birthday: DateTime.fromMillisecondsSinceEpoch(jsonMember["birthday"].seconds * 1000),
      deathday: jsonMember["birthday"] != null
          ? DateTime.fromMillisecondsSinceEpoch(jsonMember["birthday"].seconds * 1000)
          : null,
      fatherId: jsonMember["father"],
      motherId: jsonMember["mother"],
      description: jsonMember["description"],
    );
  }

  Map<String, dynamic> serialize() {
    return {
      "firstName": this.firstName,
      "middleName": this.middleName,
      "gender": this.gender,
      "birthday": Timestamp((birthday.millisecondsSinceEpoch * 0.001).toInt(), 0),
      "deathday":
          deathday == null ? null : Timestamp((deathday.millisecondsSinceEpoch * 0.001).toInt(), 0),
      "father": this.fatherId,
      "mother": this.motherId,
      "description": this.description,
    };
  }
}
