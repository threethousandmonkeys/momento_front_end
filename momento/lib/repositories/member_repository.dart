import 'package:momento/models/member.dart';
import 'package:momento/services/firestore_service.dart';

class MemberRepository {
  final _firestore = FirestoreService();

  Future<Member> getMember(String memberId) async {
    final Map<String, dynamic> memberJson = await _firestore.getDocument("member", memberId);
    if (memberJson != null) {
      return Member.parseMember(memberJson);
    } else {
      return null;
    }
  }

  Future<String> createMember(Member member) async {
    final memberId = await _firestore.createDocument(
      collection: "member",
      jsonData: member.serialize(),
    );
    return memberId;
  }

  void updateMember(String memberId, Member member) {}

  void deleteMember(String memberId) {}
}
