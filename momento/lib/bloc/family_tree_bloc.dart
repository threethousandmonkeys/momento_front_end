import 'dart:async';

import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/repositories/member_repository.dart';

class FamilyTreeBloc {
  final _memberRepository = MemberRepository();

  final _membersController = StreamController<List<Member>>();
  StreamSink<List<Member>> get _inMembers => _membersController.sink;
  Stream<List<Member>> get members => _membersController.stream;

  FamilyTreeBloc(Family family) {
    _updateMembers(family);
  }

  Future<Null> _updateMembers(Family family) async {
    final members = await _memberRepository.getFamilyMembers(family);
    _inMembers.add(members);
  }
}
