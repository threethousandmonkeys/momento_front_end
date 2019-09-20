import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repository/family_repository.dart';
import 'package:momento/screens/profile_page/artefact_gallery.dart';
import 'package:momento/screens/profile_page/family_tree.dart';

class ProfileBloc {
  String familyId;
  Family family;

  List<Member> members;
  List<Artefact> artefacts;
  List<Event> events;

  FamilyRepository _familyRepository = FamilyRepository();

  ProfileBloc(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: 3);
  }

  Future<Null> init(String uid) async {
    familyId = uid;
    family = await _familyRepository.getFamily(uid);
    await _getMembers();
    await _getArtefacts();
    await _getEvents();
    tabs = [
      FamilyTree(familyId),
      ArtefactGallery(),
      FamilyTree(familyId),
    ];
  }

  Future<Null> _getMembers() async {}

  Future<Null> _getArtefacts() async {}

  Future<Null> _getEvents() async {}

  TabController tabController;

  /// 3 components under family profile page
  List<Widget> tabs;
}
