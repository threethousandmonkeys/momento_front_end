import 'package:momento/models/artefact.dart';
import 'package:momento/services/firestore_service.dart';

class ArtefactRepository {
  final _firestore = FirestoreService();

  Future<String> createArtefact(Artefact artefact) async {
    final artefactId = await _firestore.createDocument(
      collection: "artefact",
      jsonData: artefact.serialize(),
    );
    return artefactId;
  }

  Future<Artefact> getArtefactById(String id) async {
    final jsonArtefact = await _firestore.getDocument("artefact", id);
    return Artefact.parseArtefact(id, jsonArtefact);
  }

  Future<Null> updateArtefact(Artefact artefact) async {
    await _firestore.updateDocument(
      collection: "artefact",
      documentId: artefact.id,
      newData: artefact.serialize(),
    );
  }
}
