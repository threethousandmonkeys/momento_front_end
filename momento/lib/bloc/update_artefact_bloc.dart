import 'dart:io';

import 'package:momento/models/artefact.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class UpdateArtefactBloc {
  final _artefactRepository = ArtefactRepository();
  final _cloudStorageService = CloudStorageService();

  Artefact artefact;

  UpdateArtefactBloc(Artefact oldArtefact) {
    // a hacky way to clone (deep copy), amazing
    artefact = Artefact.parseArtefact(oldArtefact.id, oldArtefact.serialize());
  }

  File photo;

  String validate() {
    if (artefact.name == "") {
      return "name";
    }
    return "";
  }

  Future<Artefact> updateArtefact(Family family) async {
    // update photo
    String photoUrl = artefact.photo;
    String thumbnailUrl = artefact.thumbnail;
    if (photo != null) {
      // delete old photo
      _cloudStorageService.deletePhoto(artefact.photo);
      if (artefact.thumbnail != null) {
        _cloudStorageService.deletePhoto(artefact.thumbnail);
      }
      // upload new photo
      final fileName = "artefact_${DateTime.now().millisecondsSinceEpoch}";
      photoUrl = await _cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);
      thumbnailUrl = null;
    }

    Artefact newArtefact = Artefact(
      id: artefact.id,
      name: artefact.name,
      dateCreated: artefact.dateCreated,
      originalOwnerId: artefact.originalOwnerId,
      currentOwnerId: artefact.currentOwnerId,
      description: artefact.description,
      photo: photoUrl,
      thumbnail: thumbnailUrl,
    );
    await _artefactRepository.updateArtefact(newArtefact);
    return newArtefact;
  }
}
