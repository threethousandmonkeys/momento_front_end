import 'dart:io';
import 'package:momento/models/artefact.dart';
import 'package:momento/models/family.dart';

class AddNewArtefactBloc {
  final artefactRepository;
  final cloudStorageService;
  final familyRepository;

  AddNewArtefactBloc(this.artefactRepository, this.cloudStorageService, this.familyRepository);

  String name = "";
  DateTime dateCreated;
  String originalOwner;
  String currentOwner;
  String description = "";
  File photo;

  // validations for testing 
  String validate() {
    if (name == "") {
      return "";
    }
    if (currentOwner == null) {
      return null;
    }
    if (photo == null) {
      return null;
    }
    return "";
  }

  // upload photo to cloud, return a retrieval path
  Future<Artefact> addNewArtefact(Family family) async {
    final fileName = "artefact_${DateTime.now().millisecondsSinceEpoch}";
    final url = await cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);
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
    final artefactId = await artefactRepository.createArtefact(newArtefact);
    await familyRepository.addArtefact(family, artefactId);
    newArtefact.id = artefactId;
    return newArtefact;
  }
}
