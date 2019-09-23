import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/screens/profile_page/artefact_gallery.dart';
import 'package:momento/screens/profile_page/family_tree.dart';
import 'package:momento/services/cloud_storage_service.dart';

class ProfileBloc {
  Family family;
  List<Member> members;

  final _familyRepository = FamilyRepository();
  final _memberRepository = MemberRepository();
  final _cloudStorageService = CloudStorageService();

  TabController tabController;

  /// 3 components under family profile page
  List<Widget> tabs;

  ProfileBloc(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: 3);
  }

  Future<Null> init(String uid) async {
    family = await _familyRepository.getFamily(uid);
    members = await _memberRepository.getFamilyMembers(family);
    String url = await _cloudStorageService.getPhoto("member/" + members[2].id);
    print(url);
    tabs = [
      FamilyTree(family, members),
      ArtefactGallery(),
      FamilyTree(family, members),
    ];
  }
}
