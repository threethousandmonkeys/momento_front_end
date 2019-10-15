import 'dart:async';
import 'package:flutter/material.dart';
import 'package:momento/services/auth_service.dart';

/// Business Logic Component for authentication
class SignInBloc {

  final _auth;
  final _familyRepository;
  final _secureStorage;
  final _snackBarService;

  SignInBloc(this._auth, this._familyRepository, this._secureStorage, this._snackBarService);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ///  For recording the inputs in the text field:
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();
  final familyNameController = TextEditingController();

  AuthUser authUser;

  Future<AuthUser> signUp({String email, String password, String name}) async {
    AuthUser authUser;
    try {
      authUser = await _auth.signUp(
        email: email,
        password: password,
      );
      await _familyRepository.createFamily(authUser.uid, name, email);
      await _secureStorage.write(key: "uid", value: authUser.uid);
      await _secureStorage.write(key: "familyName", value: name);
      await _secureStorage.write(key: "numPhotos", value: '0');
    } catch (e) {
      switch (e.code) {
        case "ERROR_WEAK_PASSWORD":
          _snackBarService.showInSnackBar(scaffoldKey, "Password is too weak! Min 6 chars");
          break;
        case "ERROR_INVALID_EMAIL":
          _snackBarService.showInSnackBar(scaffoldKey, "Invalid Email Format");
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          _snackBarService.showInSnackBar(scaffoldKey, "Email is already in use");
          break;
        default:
          break;
      }
      return null;
    }
    if (authUser != null) {
      await _familyRepository.createFamily(authUser.uid, name, email);
      await _secureStorage.write(key: "uid", value: authUser.uid);
      await _secureStorage.write(key: "familyName", value: name);
    }
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
          _snackBarService.showInSnackBar(scaffoldKey, "Invalid Email Format");
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
    await _secureStorage.write(key: "numPhotos", value: '0');
    return authUser;
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    await _secureStorage.deleteAll();
  }
}
