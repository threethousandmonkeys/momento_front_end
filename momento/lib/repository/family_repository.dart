import 'package:momento/models/family.dart';
import 'package:momento/services/firestore_service.dart';
import 'package:momento/services/auth_service.dart';

class FamilyRepository {
  final _firestore = FirestoreService();

  Future<Null> createFamily(Family family, AuthUser user) async {
    final aha = await _firestore.createDocument(
      "family",
      user.uid,
      family.serialize(),
    );
    print(aha);
  }

  Future<Family> getFamily(String familyId) async {
    final Map<String, dynamic> jsonFamily = await _firestore.getDocument("family", familyId);
    if (jsonFamily != null) {
      return Family.parseFamily(jsonFamily);
    } else {
      return null;
    }
  }
}
