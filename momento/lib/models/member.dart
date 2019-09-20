import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { Male, Female, Other }

/// a model to represent family, which store the name and description and email
class Member {
  String firstName;
  String middleName;
  String gender;
  DateTime birthday;
  DateTime deathday;
  String description;
  String photoId;

  Member({
    this.firstName,
    this.middleName,
    this.gender,
    this.birthday,
    this.deathday,
    this.description,
    this.photoId,
  });

  static Future<Member> parseMember(Map<String, dynamic> jsonMember) async {
    return Member(
      firstName: jsonMember["firstName"],
      middleName: jsonMember["middleName"],
      gender: jsonMember["gender"],
      birthday: DateTime.fromMillisecondsSinceEpoch(jsonMember["birthday"].seconds * 1000),
      deathday: jsonMember["birthday"] != null
          ? DateTime.fromMillisecondsSinceEpoch(jsonMember["birthday"].seconds * 1000)
          : null,
      description: jsonMember["description"],
      photoId: jsonMember["photoId"],
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
      "description": this.description,
      "photoId": this.photoId,
    };
  }
}
