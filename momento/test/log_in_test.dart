import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:momento/bloc/sign_in_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/services/auth_service.dart';
import 'package:momento/services/snack_bar_service.dart';

// mocks the repository and services
class MockSecureStorage extends Mock implements FlutterSecureStorage {}
class MockSnackBarService extends Mock implements SnackBarService {}

class MockAuthService {
  MockAuthService({this.userId});
  String userId;
  bool didRequestSignIn = false;
  Future<AuthUser> signIn({String email, String password}) async {
    didRequestSignIn = true;
    if (userId != null) {
      return AuthUser(uid: userId);
    } else {
      return null;
    }
  }
}

class MockFamilyRepository {
  MockFamilyRepository({this.familyId});
  String familyId;
  Future<Family> getFamily(String familyId) async {
    if (familyId != null) {
      return Family(id: familyId);
    } else {
      return null;
    }
  }
}

void main() {
  SignInBloc signInBloc;

  group("Log in:", () {
    
    test("Invalid user", () async {
      signInBloc = SignInBloc(
        MockAuthService(userId: null),
        MockFamilyRepository(familyId: null),
        MockSecureStorage(),
        MockSnackBarService()
      );

      final AuthUser user = await signInBloc.signIn(
        email: "test@test.gov",
        password: "123456",
      );
      expect(user == null, true);
    });
    
    test("Valid user", () async {
      signInBloc = SignInBloc(
        MockAuthService(userId: "0kURFq7NPggoS5srF4UIKfyZpbc2"),
        MockFamilyRepository(familyId: "0kURFq7NPggoS5srF4UIKfyZpbc2"),
        MockSecureStorage(),
        MockSnackBarService()
      );
      
      final AuthUser user = await signInBloc.signIn(
        email: "test@test.gov",
        password: "123456",
      );
      expect(user != null, true);
    });
  });

  //   group("Sign up:", () {
  //   test("Invalid user", () async {
  //     final AuthUser user = await signInBloc.signUp(
  //       email: "test@test.gov",
  //       password: "123456",
  //       name: "test",
  //     );
  //     expect(user == null, true);
  //   });
  // });
}
