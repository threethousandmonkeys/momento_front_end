import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  const AuthUser({@required this.uid});
  final String uid;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // private method to create `User` from `FirebaseUser`
  AuthUser _userFromFirebase(FirebaseUser user) {
    return user == null ? null : AuthUser(uid: user.uid);
  }

  Future<AuthUser> getCurrentUser() async {
    final user = await _auth.currentUser();
    return _userFromFirebase(user);
  }

  Stream<AuthUser> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<AuthUser> signIn({String email, String password}) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(user.user);
  }

  Future<AuthUser> signUp({String name, String email, String password}) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (user != null) {
      return _userFromFirebase(user.user);
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
