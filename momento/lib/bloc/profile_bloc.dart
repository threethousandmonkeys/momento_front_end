import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/screens/profile_page/artefact_gallery.dart';
import 'package:momento/screens/profile_page/family_tree.dart';

class ProfileBloc {
  String familyId;
  Family family;

  FamilyRepository _familyRepository = FamilyRepository();

  ProfileBloc(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: 3);
  }

  Future<Null> init(String uid) async {
    familyId = uid;
    family = await _familyRepository.getFamily(uid);
    tabs = [
      FamilyTree(familyId, family),
      ArtefactGallery(),
      FamilyTree(familyId, family),
    ];
  }

  TabController tabController;

  /// 3 components under family profile page
  List<Widget> tabs;
}
