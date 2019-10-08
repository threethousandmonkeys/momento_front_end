import 'dart:io';

import 'package:momento/models/artefact.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class AddNewArtefactBloc {
  final _artefactRepository = ArtefactRepository();
  final _cloudStorageService = CloudStorageService();
  final _familyRepository = FamilyRepository();

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

  /// upload photo to cloud, return a retrieval path
  Future<Artefact> addNewArtefact(Family family) async {
    final fileName = "artefact_${DateTime.now().millisecondsSinceEpoch}";
    final url = await _cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);
    Artefact newArtefact = Artefact(
      id: null,
      name: name,
      dateCreated: dateCreated,
      originalOwnerId: originalOwner,
      currentOwnerId: currentOwner,
      description: description,
      photo: url,
      thumbnail: null,
    );
    final artefactId = await _artefactRepository.createArtefact(newArtefact);
    await _familyRepository.addArtefact(family, artefactId);
    newArtefact.id = artefactId;
    return newArtefact;
  }
}
