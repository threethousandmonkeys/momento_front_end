enum Gender { Male, Female, Other }

/// a model to represent family, which store the name and description and email
class Member {
  String firstName;
  String middleName;
  Gender gender;
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
      gender: jsonMember["gender"],
      birthday: DateTime.fromMillisecondsSinceEpoch(jsonMember["birthday"].seconds * 1000),
      deathday: null,
      description: jsonMember["description"],
      photoId: jsonMember["photoId"],
    );
  }
}
