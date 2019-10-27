import 'dart:io';
import 'package:momento/models/artefact.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

/// Business logical：
/// For adding new artifacts. Including upload the photos into
/// cloud and return a path for later use

class AddNewArtefactBloc {
  final ArtefactRepository artefactRepository;
  final CloudStorageService cloudStorageService;
  final FamilyRepository familyRepository;

  AddNewArtefactBloc(
    this.artefactRepository,
    this.cloudStorageService,
    this.familyRepository,
  );

  String name = "";
  DateTime dateCreated;
  String originalOwner;
  String currentOwner;
  String description = "";
  File photo;

  /// validations for testing
  String validate() {
    if (name == "") {
      return "name";
    }
    if (currentOwner == null) {
      return "currentOwner";
    }
    if (photo == null) {
      return "photo";
    }
    return "";
  }

  /// upload photo to cloud, return a retrieval path
  Future<Artefact> addNewArtefact(Family family) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final url = await cloudStorageService.uploadPhotoAt(
        "${family.id}/", "artefact_$id", photo);
    Artefact newArtefact = Artefact(
      id: id,
      name: name,
      dateCreated: dateCreated,
      originalOwnerId: originalOwner,
      currentOwnerId: currentOwner,
      description: description,
      photo: url,
      thumbnail: null,
    );
    await artefactRepository.createArtefact(id, newArtefact);
    await familyRepository.addArtefact(family, id);
    return newArtefact;
  }
}
