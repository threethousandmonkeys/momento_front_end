import 'dart:async';

import 'package:momento/services/auth_service.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/models/family.dart';
import 'package:rxdart/rxdart.dart';

/// Business Logic Component for authentication
class AuthBloc {
  final AuthService _auth = AuthService();
  final FamilyRepository _familyRepository = FamilyRepository();

  final _authUserController = BehaviorSubject<AuthUser>();
  Function(AuthUser) get _setAuthUser => _authUserController.add;
  Stream<AuthUser> get getAuthUser => _authUserController.stream;

  AuthBloc() {
    _auth.onAuthStateChanged.listen(_handleAuthStateChange);
  }

  void _handleAuthStateChange(AuthUser user) {
    if (_authUserController.value == null) {
      if (user != null) {
        print("adding" + user.uid);
        _setAuthUser(user);
      }
    } else {
      if (user == null) {
        _setAuthUser(null);
      }
    }
  }

  Future<AuthUser> signUp({String email, String password, String name}) async {
    final AuthUser authUser = await _auth.signUp(
      email: email,
      password: password,
    );
    Family defaultFamily = Family(
      name: name,
      description: "This family is too lazy to write any description.",
      email: email,
      members: [],
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

  Future<Null> signOut() async {
    await _auth.signOut();
  }
}
