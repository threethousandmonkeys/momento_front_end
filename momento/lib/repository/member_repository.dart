import 'package:momento/models/member.dart';
import 'package:momento/services/firestore_service.dart';

class MemberRepository {
  final _firestore = FirestoreService();

  void createMember(Member member) async {}

  Future<Member> getMember(String memberId) async {
    final Map<String, dynamic> memberJson = await _firestore.getDocument("person", memberId);
    if (memberJson != null) {
      return Member.parseMember(memberJson);
    } else {
      return null;
    }
  }

  void updateMember(String memberId, Member member) {}

  void deleteMember(String memberId) {}
}
