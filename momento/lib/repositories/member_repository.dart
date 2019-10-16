import 'package:momento/models/member.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/services/firestore_service.dart';

class MemberRepository {
  final _firestore = FirestoreService();
  final _cloudStorage = CloudStorageService();

  // get individual members by its user id
  Future<Member> getMemberById(String familyId, String memberId) async {
    final Map<String, dynamic> memberJson = await _firestore.getDocument("member", memberId);
    final member = Member.parseMember(memberId, memberJson);
    if (member.thumbnail == null) {
      final thumbnail = await _cloudStorage.getPhoto("$familyId/member_$memberId@thumbnail.jpg");
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

  void deleteMember(String memberId) {}
}
