import 'dart:io';

import 'package:flutter/material.dart';
import 'package:momento/models/artefact.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class AddNewArtefactBloc {
  final _artefactRepository = ArtefactRepository();
  final _cloudStorageService = CloudStorageService();
  final _familyRepository = FamilyRepository();
  final dateCreatedController = TextEditingController();

  final List<Member> members;
  AddNewArtefactBloc(this.members);

  String name = "";
  DateTime dateCreated;
  String originalOwner;
  String currentOwner;
  String description = "";
  File photo;

  String validate() {
    if (name == "") {
      return "name";
    }
    if (currentOwner == null) {
      return "current owner";
    }
    if (photo == null) {
      return "photo";
    }
    return "";
  }

  Future<Null> addNewArtefact(Family family) async {
    /// upload photo to cloud, return a retrieval path
    Artefact newArtefact = Artefact(
      id: null,
      name: name,
      dateCreated: dateCreated,
      originalOwnerId: originalOwner,
      currentOwnerId: currentOwner,
      description: description,
    );
    final artefactId = await _artefactRepository.createArtefact(newArtefact);
    await _cloudStorageService.uploadPhotoAt("${family.id}/artefacts/original/", artefactId, photo);
    await _familyRepository.addArtefact(family, artefactId);
  }
}
