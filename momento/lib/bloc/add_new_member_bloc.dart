import 'dart:io';

import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class AddNewMemberBloc {
  final _memberRepository = MemberRepository();
  final _familyRepository = FamilyRepository();
  final _cloudStorageService = CloudStorageService();

  final List<Member> members;

  String firstName = "";
  String middleName = "";
  String gender = "";
  DateTime birthday;
  DateTime deathday;
  String description = "";
  String father;
  String mother;
  File photo;

  List<Member> fathers;
  List<Member> mothers;

  AddNewMemberBloc(this.members) {
    updateFathers();
    updateMothers();
  }

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
    if (photo == null) {
      return "photo";
    }
    return "";
  }

  /// upload photo to cloud, return a retrieval path
  Future<Member> addNewMember(Family family) async {
    final fileName = "member_${DateTime.now().millisecondsSinceEpoch}";
    final url = await _cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);
    Member newMember = Member(
      id: null,
      firstName: firstName,
      middleName: middleName,
      gender: gender,
      birthday: birthday,
      deathday: deathday,
      fatherId: father,
      motherId: mother,
      description: description,
      photo: url,
      thumbnail: null,
    );
    final memberId = await _memberRepository.createMember(newMember);
    await _familyRepository.addMember(family, memberId);
    newMember.id = memberId;
    return newMember;
  }

  void updateFathers() {
    List<Member> possibleFathers = List<Member>.from(members);
    possibleFathers.retainWhere((f) => f.gender == "Male");
    if (birthday != null) {
      possibleFathers.retainWhere((f) => f.birthday.isBefore(birthday));
    }
    fathers = possibleFathers;
  }

  void updateMothers() {
    List<Member> possibleMothers = List<Member>.from(members);
    possibleMothers.retainWhere((f) => f.gender == "Female");
    if (birthday != null) {
      possibleMothers.retainWhere((f) => f.birthday.isBefore(birthday));
    }
    mothers = possibleMothers;
  }
}
