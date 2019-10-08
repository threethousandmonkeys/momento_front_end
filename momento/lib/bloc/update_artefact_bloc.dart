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
    if (photo != null) {
      // delete old photo
      _cloudStorageService.deletePhoto(artefact.photo);
      if (artefact.thumbnail != null) {
        _cloudStorageService.deletePhoto(artefact.thumbnail);
      }
      // upload new photo
      final fileName = "artefact_${DateTime.now().millisecondsSinceEpoch}";
      artefact.photo = await _cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);
      artefact.thumbnail = null;
    }

    await _artefactRepository.updateArtefact(artefact);
    return artefact;
  }
}
