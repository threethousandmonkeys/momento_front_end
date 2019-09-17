import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  const User({@required this.uid});
  final String uid;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  // private method to create `User` from `FirebaseUser`
  User _userFromFirebase(FirebaseUser user) {
    return user == null ? null : User(uid: user.uid);
  }

  Future<User> getCurrentUser() async {
    final user = await _auth.currentUser();
    return _userFromFirebase(user);
  }

  Stream<User> get onAuthStateChanged {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<User> signIn({String email, String password}) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromFirebase(user.user);
  }

  Future<User> signUp({String name, String email, String password}) async {
    final user = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestore.collection("family").document(user.user.uid).setData({
      "name": name,
      "description": "The family is too lazy to add a description",
      "email": email,
    });
    return _userFromFirebase(user.user);
  }

  Future<void> signOut() async {
    return _auth.signOut();
  }
}
