import 'dart:async';

import 'package:momento/models/family.dart';
import 'package:momento/repository/family_repository.dart';
import 'package:momento/services/auth_service.dart';

class ProfileBloc {
  final FamilyRepository _familyRepository = FamilyRepository();

  Future<Family> getFamily(AuthUser authUser) async {
    Family family = await _familyRepository.getFamily(authUser.uid);
    return family;
  }
}
