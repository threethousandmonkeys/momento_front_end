import 'package:momento/models/family.dart';
import 'package:momento/services/firestore_service.dart';
import 'package:momento/services/auth_service.dart';

class FamilyRepository {
  final _firestore = FirestoreService();

  Future<Null> createFamily(Family family, String uid) async {
    await _firestore.createDocumentById(
      "family",
      uid,
      family.serialize(),
    );
  }

  Future<Family> getFamily(String familyId) async {
    final Map<String, dynamic> jsonFamily = await _firestore.getDocument("family", familyId);
    if (jsonFamily != null) {
      return Family.parseFamily(familyId, jsonFamily);
    } else {
      return null;
    }
  }

  Future<Null> addMember(Family family, String memberId) async {
    final newMembers = List<String>.from(family.members);
    newMembers.add(memberId);
    await _firestore.updateDocument(
      collection: "family",
      documentId: family.id,
      field: "members",
      newData: newMembers,
    );
  }

  Future<Null> addPhoto(Family family) async {
    await _firestore.updateDocument(
      collection: "family",
      documentId: family.id,
      field: "num_photos",
      newData: family.numPhotos + 1,
    );
  }
}
