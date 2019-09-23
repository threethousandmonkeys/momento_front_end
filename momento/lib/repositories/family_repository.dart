import 'package:momento/models/family.dart';
import 'package:momento/services/firestore_service.dart';
import 'package:momento/services/auth_service.dart';

class FamilyRepository {
  final _firestore = FirestoreService();

  Future<Null> createFamily(Family family, AuthUser user) async {
    await _firestore.createDocumentById(
      "family",
      user.uid,
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

  Future<Null> addMember(String familyId, String memberId) async {
    Family oldFamily = await getFamily(familyId);
    List<String> newMembers = oldFamily.members;
    newMembers.add(memberId);
    await _firestore.updateDocument(
      collection: "family",
      documentId: familyId,
      field: "members",
      newData: newMembers,
    );
  }
}
