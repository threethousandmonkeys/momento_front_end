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
}
