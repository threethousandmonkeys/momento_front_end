import 'dart:async';
import 'package:flutter/material.dart';
import 'package:momento/services/auth_service.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:momento/services/snack_bar_service.dart';

/// Business Logic Component for authentication
class SignInBloc {
  final _auth = AuthService();
  final _familyRepository = FamilyRepository();
  final _secureStorage = FlutterSecureStorage();
  final _snackBarService = SnackBarService();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AuthUser authUser;

  Future<AuthUser> signUp({String email, String password, String name}) async {
    final AuthUser authUser = await _auth.signUp(
      email: email,
      password: password,
    );
    await _familyRepository.createFamily(authUser.uid, name, email);
    await _secureStorage.write(key: "uid", value: authUser.uid);
    await _secureStorage.write(key: "familyName", value: name);
    return authUser;
  }

  Future<AuthUser> signIn({String email, String password}) async {
    AuthUser authUser;
    try {
      authUser = await _auth.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      switch (e.code) {
        case "ERROR_USER_NOT_FOUND":
          _snackBarService.showInSnackBar(scaffoldKey, "User Not Found");
          break;
        case "ERROR_INVALID_EMAIL":
          _snackBarService.showInSnackBar(scaffoldKey, "Wrong Email Format");
          break;
        case "ERROR_WRONG_PASSWORD":
          _snackBarService.showInSnackBar(scaffoldKey, "Wrong Password");
          break;
        default:
          break;
      }
      return null;
    }
    await _secureStorage.write(key: "uid", value: authUser.uid);
    final family = await _familyRepository.getFamily(authUser.uid);
    await _secureStorage.write(key: "familyName", value: family.name);
    return authUser;
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: "uid");
    await _secureStorage.delete(key: "familyName");
  }
}
