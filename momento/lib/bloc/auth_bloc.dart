import 'dart:async';

import 'package:momento/services/auth_service.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/models/family.dart';

class AuthBloc {
  final AuthService _auth = AuthService();
  final FamilyRepository _familyRepository = FamilyRepository();

  final _authFamilyController = StreamController<AuthUser>();
  StreamSink<AuthUser> get _inAuthUser => _authFamilyController.sink;
  Stream<AuthUser> get authUser => _authFamilyController.stream;

  AuthBloc() {
    _auth.onAuthStateChanged.listen(_handleAuthStateChange);
  }

  AuthUser currentUser;

  void _handleAuthStateChange(AuthUser user) {
    if (currentUser == null) {
      if (user != null) {
        currentUser = user;
        _inAuthUser.add(user);
      } else {
        _inAuthUser.add(null);
      }
    } else {
      if (user == null) {
        _inAuthUser.add(null);
        currentUser = null;
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
