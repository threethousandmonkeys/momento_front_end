import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repository/member_repository.dart';
import 'package:momento/repository/family_repository.dart';

class AddNewBloc {
  MemberRepository _memberRepository = MemberRepository();
  FamilyRepository _familyRepository = FamilyRepository();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController dateOfDeathController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<Null> addNewMember(String familyId) async {
    String firstName = firstNameController.text;
    String description = descriptionController.text;
    Member newMember = Member(
      firstName: firstName,
      middleName: null,
      gender: "Male",
      birthday: DateTime.now(),
      deathday: DateTime.now(),
      description: description,
      photoId: null,
    );
    final memberId = await _memberRepository.createMember(newMember);
    await _familyRepository.addMember(familyId, memberId);
  }

  void pickImage() async {
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}
