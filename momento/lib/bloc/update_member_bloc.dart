import 'dart:io';

import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class UpdateMemberBloc {
  final _memberRepository = MemberRepository();
  final _cloudStorageService = CloudStorageService();

  Member member;
  List<Member> members;

  UpdateMemberBloc(Member oldMember, this.members) {
    // a hacky way to clone (deep copy), amazing
    member = Member.parseMember(oldMember.id, oldMember.serialize());

    updateFathers();
    updateMothers();
  }

  void updateFathers() {
    List<Member> possibleFathers = List<Member>.from(members);
    possibleFathers.retainWhere((f) => f.gender == "Male");
    if (member.birthday != null) {
      possibleFathers.retainWhere((f) => f.birthday.isBefore(member.birthday));
    }
    fathers = possibleFathers;
  }

  void updateMothers() {
    List<Member> possibleMothers = List<Member>.from(members);
    possibleMothers.retainWhere((f) => f.gender == "Female");
    if (member.birthday != null) {
      possibleMothers.retainWhere((f) => f.birthday.isBefore(member.birthday));
    }
    mothers = possibleMothers;
  }

  List<Member> fathers;
  List<Member> mothers;

  File photo;

  String validate() {
    if (member.firstName == "") {
      return "name";
    }
    return "";
  }

  Future<Member> updateMember(Family family) async {
    // update photo
    if (photo != null) {
      // delete old photo
      _cloudStorageService.deletePhoto(member.photo);
      if (member.thumbnail != null) {
        _cloudStorageService.deletePhoto(member.thumbnail);
      }
      // upload new photo
      final fileName = "member_${DateTime.now().millisecondsSinceEpoch}";
      member.photo = await _cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);
      member.thumbnail = null;
    }

    await _memberRepository.updateMember(member);
    return member;
  }
}
