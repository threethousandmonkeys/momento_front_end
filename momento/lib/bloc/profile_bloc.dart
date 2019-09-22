import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/screens/profile_page/artefact_gallery.dart';
import 'package:momento/screens/profile_page/family_tree.dart';

class ProfileBloc {
  Family family;

  final _familyRepository = FamilyRepository();

  TabController tabController;

  /// 3 components under family profile page
  List<Widget> tabs;

  ProfileBloc(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: 3);
  }

  Future<Null> init(String uid) async {
    family = await _familyRepository.getFamily(uid);
    tabs = [
      FamilyTree(family),
      ArtefactGallery(),
      FamilyTree(family),
    ];
  }
}
