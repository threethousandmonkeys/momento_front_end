import 'package:momento/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:momento/repositories/family_repository.dart';

void main() {
  // final _auth = AuthService();
  // AuthUser authUser;

 final FirebaseAuth _auth = FirebaseAuth.instance;

  test("Wrong email", () async {
    try {
      // final AuthUser authUser = await _auth.signIn(
      //   email: "test@123",
      //   password: "123456",
      // );
     final user = await _auth.createUserWithEmailAndPassword(
       email: "test@123",
       password: "123456",
     );
    } catch (e) {
      print(e);
//      expect(e.code, "ERROR_INVALID_EMAIL");
    }
  });

  final _familyRepository = FamilyRepository();

  test("Create family", () async {
      await _familyRepository.createFamily("siI6RP184bgk1Orvb9Zo8lN7phO2", "test", "test@mail.com");
      expect(_familyRepository.getFamily("siI6RP184bgk1Orvb9Zo8lN7phO2"), !null);
  });

}
