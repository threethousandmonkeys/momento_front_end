import 'dart:async';

import 'package:momento/services/auth_service.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Business Logic Component for authentication
class SignInBloc {
  final _auth = AuthService();
  final _familyRepository = FamilyRepository();
  final _secureStorage = FlutterSecureStorage();

  AuthUser authUser;

  Future<AuthUser> signUp({String email, String password, String name}) async {
    final AuthUser authUser = await _auth.signUp(
      email: email,
      password: password,
    );
    await _familyRepository.createFamily(authUser.uid, name, email);
    await _secureStorage.write(key: "uid", value: authUser.uid);
    return authUser;
  }

  Future<AuthUser> signIn({String email, String password}) async {
    final AuthUser authUser = await _auth.signIn(
      email: email,
      password: password,
    );
    await _secureStorage.write(key: "uid", value: authUser.uid);
    return authUser;
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: "uid");
  }
}
