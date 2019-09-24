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
import 'package:firebase_auth/firebase_auth.dart';

class ProfileBloc {
  final _auth = FirebaseAuth.instance;
  final _familyRepository = FamilyRepository();
  final _memberRepository = MemberRepository();
  final _cloudStorageService = CloudStorageService();
  final _secureStorage = FlutterSecureStorage();

  Family family;
  List<Member> members;
  TabController tabController;
  List<Widget> tabs;
  List<String> photos = [];

  Future<Null> init(BuildContext context, TickerProvider vsync) async {
    final uid = await _authenticate(context);
    await _updateProfile(uid);
    tabController = TabController(vsync: vsync, length: 3);
    tabs = [
      FamilyTree(family, members),
      ArtefactGallery(family, members),
      FamilyTree(family, members),
    ];
  }

  Future<String> _authenticate(BuildContext context) async {
    String uid;
    uid = await _secureStorage.read(key: "uid");
    if (uid == null) {
      uid = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
    return uid;
  }

  Future<Null> _updateProfile(String uid) async {
    family = await _familyRepository.getFamily(uid);
    members = await _memberRepository.getFamilyMembers(family);
    for (int i = photos.length; i < family.numPhotos; i++) {
      /// TODO: Get thumbnails
      String url = "${family.id}/photos/original/${i.toString()}";
      photos.add(await _cloudStorageService.getPhoto(url));
    }
  }

  Future<Null> uploadPhoto(File photo) async {
    String fileName = family.numPhotos.toString();
    await _cloudStorageService.uploadPhotoAt("${family.id}/photos/original/", fileName, photo);
    _familyRepository.addPhoto(family);
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: "uid");
  }
}
