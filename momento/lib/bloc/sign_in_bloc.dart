import 'dart:async';

import 'package:momento/services/auth_service.dart';
import 'package:momento/repository/family_repository.dart';
import 'package:momento/models/family.dart';

class SignInBloc {
  final AuthService _auth = AuthService();
  final FamilyRepository _familyRepository = FamilyRepository();

  Future<AuthUser> signUp({String email, String password, String name}) async {
    final AuthUser authUser = await _auth.signUp(
      email: email,
      password: password,
    );
    Family defaultFamily = Family(
      name: name,
      description: "This family is too lazy to write any description.",
      email: email,
    );
    await _familyRepository.createFamily(defaultFamily, authUser);
    return authUser;
  }

  Future<AuthUser> signIn({String email, String password}) async {
    final AuthUser user = await _auth.signIn(
      email: email,
      password: password,
    );
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }
}
