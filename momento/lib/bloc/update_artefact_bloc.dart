import 'dart:io';

import 'package:momento/models/artefact.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class UpdateArtefactBloc {
  final _artefactRepository = ArtefactRepository();
  final _cloudStorageService = CloudStorageService();
  final _familyRepository = FamilyRepository();

  Artefact artefact;
  Future<String> getPhoto;

  UpdateArtefactBloc(Family family, Artefact oldArtefact) {
    // a hacky way to clone (deep copy), amazing
    artefact = Artefact.parseArtefact(oldArtefact.id, oldArtefact.serialize());
  }

  File photo;

  String validate() {
    if (artefact.name == "") {
      return "name";
    }
    if (photo == null) {
      return "photo";
    }
    return "";
  }

//  Future<Artefact> addNewArtefact(Family family) async {
//    /// upload photo to cloud, return a retrieval path
//    Artefact newArtefact = Artefact(
//      id: null,
//      name: name,
//      dateCreated: dateCreated,
//      originalOwnerId: originalOwner,
//      currentOwnerId: currentOwner,
//      description: description,
//    );
//    final artefactId = await _artefactRepository.createArtefact(newArtefact);
//    await _cloudStorageService.uploadPhotoAt("${family.id}/artefacts/original/", artefactId, photo);
//    await _familyRepository.addArtefact(family, artefactId);
//    newArtefact.id = artefactId;
//    return newArtefact;
//  }
}
