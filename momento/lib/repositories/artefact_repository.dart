import 'package:momento/models/artefact.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/services/firestore_service.dart';

/// getting artifact entries from Firease cloud firestore and provide
/// it to the upper layers
class ArtefactRepository {
  final _firestore = FirestoreService();
  final _cloudStorage = CloudStorageService();

  Future<Null> createArtefact(String id, Artefact artefact) async {
    final artefactId = await _firestore.createDocumentById(
      "artefact",
      id,
      artefact.serialize(),
    );
    return artefactId;
  }

  Future<Artefact> getArtefactById(String familyId, String artefactId) async {
    final jsonArtefact = await _firestore.getDocument("artefact", artefactId);
    final artefact = Artefact.parseArtefact(artefactId, jsonArtefact);
    if (artefact.thumbnail == null) {
      final thumbnail = await _cloudStorage.getPhoto("$familyId/artefact_$artefactId@thumbnail");
      if (thumbnail != null) {
        artefact.thumbnail = thumbnail;
        await updateArtefact(artefact);
      }
    }
    return artefact;
  }

  Future<Null> updateArtefact(Artefact artefact) async {
    await _firestore.updateDocument(
      "artefact",
      artefact.id,
      artefact.serialize(),
    );
  }
}
