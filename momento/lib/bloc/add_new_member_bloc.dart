import 'dart:io';

import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class AddNewMemberBloc {
  final MemberRepository memberRepository;
  final FamilyRepository familyRepository;
  final CloudStorageService cloudStorageService;

  AddNewMemberBloc(
    this.memberRepository,
    this.familyRepository,
    this.cloudStorageService,
    this.members,
  ) {
    updateFathers();
    updateMothers();
  }

  final List<Member> members;

  String firstName = "";
  String lastName = "";
  String gender = "";
  DateTime birthday;
  DateTime deathday;
  String description = "";
  String father;
  String mother;
  File photo;

  List<Member> fathers;
  List<Member> mothers;

  // validations for testing
  String validate() {
    if (firstName == "") {
      return "firstName";
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
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final url = await cloudStorageService.uploadPhotoAt("${family.id}/", "member_$id", photo);
    Member newMember = Member(
      id: id,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      birthday: birthday,
      deathday: deathday,
      fatherId: father,
      motherId: mother,
      description: description,
      photo: url,
      thumbnail: null,
    );
    await memberRepository.createMember(id, newMember);
    await familyRepository.addMember(family, id);
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
