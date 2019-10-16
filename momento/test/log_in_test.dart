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

  // mocks the behaviour of signIn function, returns an authenticated user
  String userId;
  Future<AuthUser> signIn({String email, String password}) async {
    assert(email != null);
    assert(password != null);
    if (userId != null) {
      return AuthUser(uid: userId);
    } else {
      return null;
    }
  }

  // mocks the behaviour of signUp function, returns an new authenticated user
  String randomId = "0kURFq7NPggoS5srF4UIKfyZpbc2";
  Future<AuthUser> signUp({String email, String password, String name}) async {
    assert(email != null);
    assert(password != null);

    // check if it's a valid email
    int lastIdx = email.indexOf("@");
    if (!email.contains("@") || !email.substring(lastIdx).contains(".")) {
      return null;
    }
    
    // check if the password is strong enough
    if (password.length < 6) {
      return null;
    }
    return AuthUser(uid: userId);
  }
}

class MockFamilyRepository {
  MockFamilyRepository({this.familyId});
  String familyId;
  
  // mocks the behaviour of getFamily function, returns a family id
  Future<Family> getFamily(String familyId) async {
    if (familyId != null) {
      return Family(id: familyId);
    } else {
      return null;
    }
  }

  // mocks the behaviour of createFamily function, returns nothing
  Future<Null> createFamily(String uid, String name, String email) async {
    return null;
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

  group("Sign up:", () {
    test("Invalid email, no domain", () async {
      final AuthUser user = await signInBloc.signUp(
        email: "test@test",
        password: "123456",
        name: "test",
      );
      expect(user == null, true);
    });

    test("Invalid email, incomplete email", () async {
      final AuthUser user = await signInBloc.signUp(
        email: "test.com",
        password: "123456",
        name: "test",
      );
      expect(user == null, true);
    });

    test("Invalid email, blank email", () async {
      final AuthUser user = await signInBloc.signUp(
        email: "",
        password: "123456",
        name: "test",
      );
      expect(user == null, true);
    });

    test("Password too weak", () async {
      final AuthUser user = await signInBloc.signUp(
        email: "test@test.com",
        password: "",
        name: "test",
      );
      expect(user == null, true);
    });

    test("Valid credentials, but no name", () async {
      final AuthUser user = await signInBloc.signUp(
        email: "test@test.com",
        password: "123456",
        name: "",
      );
      expect(user != null, true);
    });

    test("Valid credentials", () async {
      final AuthUser user = await signInBloc.signUp(
        email: "test@test.com",
        password: "123456",
        name: "test",
      );
      expect(user != null, true);
    });
  });
}
