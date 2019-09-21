import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:rxdart/rxdart.dart';

class AddNewMemberBloc {
  MemberRepository _memberRepository = MemberRepository();
  FamilyRepository _familyRepository = FamilyRepository();

  final _membersSubject = BehaviorSubject<List<Member>>();
  Function(List<Member>) get _setMembers => _membersSubject.add;
  Observable<List<Member>> get getMembers => _membersSubject.stream;

  String firstName = "";
  String middleName = "";
  String gender = "";
  DateTime birthday;
  DateTime deathday;
  String description = "";
  Member father;
  Member mother;
  String photoPath;

  TextEditingController birthdayTextController = TextEditingController();
  TextEditingController deathdayTextController = TextEditingController();

  AddNewMemberBloc(Family family) {
    _getMembers(family);
  }

  Future<Null> _getMembers(Family family) async {
    final members = await _memberRepository.getFamilyMembers(family);
    _setMembers(members);
    updateFathers();
    updateMothers();
  }

  List<Member> fathers;
  List<Member> mothers;

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

  void updateFathers() {
    List<Member> possibleFathers = new List<Member>.from(_membersSubject.value);
    possibleFathers.retainWhere((f) => f.gender == "Male");
    if (birthday != null) {
      possibleFathers.where((f) => f.birthday.isBefore(birthday));
    }
    fathers = possibleFathers;
  }

  void updateMothers({DateTime deathday}) {
    List<Member> possibleMothers = new List<Member>.from(_membersSubject.value);
    possibleMothers.retainWhere((f) => f.gender == "Female");
    if (birthday != null) {
      possibleMothers.where((f) => f.birthday.isBefore(birthday));
    }
    mothers = possibleMothers;
  }

  void pickImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print(image);
  }
}
