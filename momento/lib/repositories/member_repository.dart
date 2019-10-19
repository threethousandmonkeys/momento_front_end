import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/services/firestore_service.dart';

/// Getting member entries from Firease cloud firestore and provide
/// it to the upper layers
class MemberRepository {
  final _firestore = FirestoreService();
  final _cloudStorage = CloudStorageService();
  final _familyRepository = FamilyRepository();
  final _eventRepository = EventRepository();

  /// Get individual members by its user id
  Future<Member> getMemberById(String familyId, String memberId) async {
    final Map<String, dynamic> memberJson = await _firestore.getDocument("member", memberId);
    final member = Member.parseMember(memberId, memberJson);
    if (member.thumbnail == null) {
      final thumbnail = await _cloudStorage.getPhoto("$familyId/member_$memberId@thumbnail");
      if (thumbnail != null) {
        member.thumbnail = thumbnail;
        updateMember(member);
      }
    }
    return member;
  }

  Future<String> createMember(String id, Member member) async {
    final memberId = await _firestore.createDocumentById(
      "member",
      id,
      member.serialize(),
    );
    return memberId;
  }

  Future<Null> updateMember(Member member) async {
    await _firestore.updateDocument(
      "member",
      member.id,
      member.serialize(),
    );
  }

  Future<Null> deleteMember(Family family, Member member) async {
    if (member.photo != null) {
      _cloudStorage.deletePhoto(member.photo);
    }
    if (member.thumbnail != null) {
      _cloudStorage.deletePhoto(member.thumbnail);
    }
    await _firestore.deleteDocument("member", member.id);
    await _familyRepository.deleteMember(family, member.id);
  }
}
