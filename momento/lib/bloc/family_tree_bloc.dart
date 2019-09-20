import 'dart:async';

import 'package:momento/models/member.dart';
import 'package:momento/repositories/member_repository.dart';

class FamilyTreeBloc {
  final _memberRepository = MemberRepository();

  final _membersController = StreamController<List<Member>>();
  StreamSink<List<Member>> get _inMembers => _membersController.sink;
  Stream<List<Member>> get members => _membersController.stream;

  FamilyTreeBloc(String familyId, List<String> memberIds) {
    _updateMembers(memberIds);
  }

  Future<Null> _updateMembers(List<String> memberIds) async {
    final futureMembers = memberIds.map((id) => _getMember(id));
    final members = await Future.wait(futureMembers);
    _inMembers.add(members);
  }

  Future<Member> _getMember(String memberId) async {
    final member = await _memberRepository.getMember(memberId);
    return member;
  }
}
