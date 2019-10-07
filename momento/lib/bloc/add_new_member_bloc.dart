import 'dart:io';

import 'package:flutter/material.dart';
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

  TextEditingController birthdayTextController = TextEditingController();
  TextEditingController deathdayTextController = TextEditingController();

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

  Future<Member> addNewMember(Family family) async {
    /// upload photo to cloud, return a retrieval path
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
    );
    final memberId = await _memberRepository.createMember(newMember);
    await _cloudStorageService.uploadPhotoAt("${family.id}/members/original/", memberId, photo);
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
