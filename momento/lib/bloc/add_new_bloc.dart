import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/repositories/family_repository.dart';

class AddNewBloc {
  MemberRepository _memberRepository = MemberRepository();
  FamilyRepository _familyRepository = FamilyRepository();

  String firstName = "";
  String middleName = "";
  String gender = "";
  DateTime birthday;
  DateTime deathday;
  String description = "";
  String photoPath;

  TextEditingController birthdayController = TextEditingController();
  TextEditingController deathdayController = TextEditingController();

  String validate() {
    if (firstName == "") {
      return "first name";
    }
    if (gender == "") {
      return "gender";
    }
    if (birthday == null) {
      return "birthday";
    }
    return "";
  }

  Future<Null> addNewMember(String familyId) async {
    Member newMember = Member(
      firstName: firstName,
      middleName: middleName,
      gender: gender,
      birthday: birthday,
      deathday: deathday,
      description: description,
      photoId: null,
    );
    final memberId = await _memberRepository.createMember(newMember);
    await _familyRepository.addMember(familyId, memberId);
  }

  void pickImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image);
  }
}
