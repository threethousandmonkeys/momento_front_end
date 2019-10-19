import 'package:momento/models/family.dart';
import 'package:momento/services/firestore_service.dart';

/// getting family entries from Firease cloud firestore and provide
/// it to the upper layers
class FamilyRepository {
  final _firestore = FirestoreService();

  Future<Null> createFamily(String uid, String name, String email) async {
    Family defaultFamily = Family(
      name: name,
      description: "Insert family description",
      email: email,
      photos: [],
      members: [],
      artefacts: [],
      events: [],
    );
    await _firestore.createDocumentById(
      "family",
      uid,
      defaultFamily.serialize(),
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
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "members",
      newMembers,
    );
  }

  Future<Null> deleteMember(Family family, String memberId) async {
    final newMembers = List<String>.from(family.members);
    newMembers.removeWhere((id) => id == memberId);
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "members",
      newMembers,
    );
  }

  Future<Null> addArtefact(Family family, String artefactId) async {
    final newArtefacts = List<String>.from(family.artefacts);
    newArtefacts.add(artefactId);
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "artefacts",
      newArtefacts,
    );
  }

  Future<Null> deleteArtefact(Family family, String artefactId) async {
    final newArtefacts = List<String>.from(family.artefacts);
    newArtefacts.removeWhere((id) => id == artefactId);
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "artefacts",
      newArtefacts,
    );
  }

  Future<Null> addEvent(Family family, String eventId) async {
    final newEvents = List<String>.from(family.events);
    newEvents.add(eventId);
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "events",
      newEvents,
    );
  }

  Future<Null> deleteEvent(Family family, String eventId) async {
    final newEvents = List<String>.from(family.events);
    newEvents.removeWhere((id) => id == eventId);
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "events",
      newEvents,
    );
  }

  Future<Null> updatePhotos(Family family) async {
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "photos",
      family.photos,
    );
  }

  Future<Null> updateDescription(Family family, String description) async {
    await _firestore.updateDocumentByField(
      "family",
      family.id,
      "description",
      description,
    );
  }
}
