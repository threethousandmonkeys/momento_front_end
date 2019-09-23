import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/screens/profile_page/artefact_gallery.dart';
import 'package:momento/screens/profile_page/family_tree.dart';
import 'package:momento/screens/signin_page/sign_in_page.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileBloc {
  Family family;
  List<Member> members;

  final _familyRepository = FamilyRepository();
  final _memberRepository = MemberRepository();
  final _cloudStorageService = CloudStorageService();
  final _secureStorage = FlutterSecureStorage();

  TabController tabController;

  /// 3 components under family profile page
  List<Widget> tabs;
  List<String> photos = [];

  ProfileBloc(TickerProvider vsync) {
    tabController = TabController(vsync: vsync, length: 3);
  }

  Future<Null> authenticate(BuildContext context) async {
    String uid;
    uid = await _secureStorage.read(key: "uid");
    if (uid == null) {
      uid = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
    await _init(uid);
  }

  Future<Null> _init(String uid) async {
    family = await _familyRepository.getFamily(uid);
    members = await _memberRepository.getFamilyMembers(family);
    await updatePhotos();
    tabs = [
      FamilyTree(family, members),
      ArtefactGallery(),
      FamilyTree(family, members),
    ];
  }

  Future<Null> uploadPhoto(File photo) async {
    String fileName = family.numPhotos.toString();
    await _cloudStorageService.uploadPhotoAt("family/${family.id}/", fileName, photo);
    _familyRepository.addPhoto(family);
    // TODO: update number and referesh
  }

  Future<Null> updatePhotos() async {
    for (int i = photos.length; i < family.numPhotos; i++) {
      String url = "family/${family.id}/${i.toString()}";
      print("getting $i}");
      photos.add(await _cloudStorageService.getPhoto(url));
    }
  }
}
