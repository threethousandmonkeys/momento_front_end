import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/services/firestore_service.dart';

class MemberRepository {
  final _firestore = FirestoreService();

  Future<List<Member>> getFamilyMembers(Family family) async {
    List<String> memberIds = family.members;
    final futureMembers = memberIds.map((id) => getMemberById(id));
    final members = await Future.wait(futureMembers);
    return members;
  }

  Future<Member> getMemberById(String memberId) async {
    final Map<String, dynamic> memberJson = await _firestore.getDocument("member", memberId);
    if (memberJson != null) {
      return Member.parseMember(memberId, memberJson);
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

  Future<List<Member>> getMembersBornBefore(DateTime date, Family family) async {
    final List<Member> members = await getFamilyMembers(family);
    members.retainWhere((member) => member.birthday.isBefore(date));
    return members;
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
