// import 'package:momento/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}

//  String a = 'askjfkjsksjfk   ';
//  print(a.trim());
