import 'dart:io';

import 'package:momento/models/artefact.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

/** Business logical：
 *     For updating new artifacts. Including upload the photos into
 *     cloud
 **/

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

  Future<Artefact> updateArtefact(String familyId) async {
    // update photo
    if (photo != null) {
      // delete old photo
      if (artefact.thumbnail != null) {
        _cloudStorageService.deletePhoto(artefact.thumbnail);
      }
      // upload new photo
      final fileName = "artefact_${artefact.id}";
      artefact.photo = await _cloudStorageService.uploadPhotoAt("$familyId/", fileName, photo);
      artefact.thumbnail = null;
    }

    await _artefactRepository.updateArtefact(artefact);
    return artefact;
  }
}
