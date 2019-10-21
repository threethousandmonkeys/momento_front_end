import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:momento/bloc/add_new_member_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

/// mocks the repository and services
class MockMemberRepository extends Mock implements MemberRepository {}

class MockCloudStorageService extends Mock implements CloudStorageService {}

class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  AddNewMemberBloc addNewArtefactBloc;

  /// set up the class to be tested
  setUp(() {
    addNewArtefactBloc = AddNewMemberBloc(
        MockMemberRepository(), MockFamilyRepository(), MockCloudStorageService(), []);
  });

  test("intial page state", () {
    expect(addNewArtefactBloc.firstName, "");
    expect(addNewArtefactBloc.lastName, "");
    expect(addNewArtefactBloc.gender, "");
    expect(addNewArtefactBloc.birthday, null);
    expect(addNewArtefactBloc.deathday, null);
    expect(addNewArtefactBloc.father, null);
    expect(addNewArtefactBloc.mother, null);
    expect(addNewArtefactBloc.description, "");
    expect(addNewArtefactBloc.photo, null);
  });

  group("add artefact", () {
    test("input artefact", () {
      expect(addNewArtefactBloc.validate(), "firstName");

      addNewArtefactBloc.firstName = "test_first_name";
      expect(addNewArtefactBloc.validate(), "gender");

      addNewArtefactBloc.gender = "Male";
      expect(addNewArtefactBloc.validate(), "birthday");

      addNewArtefactBloc.birthday = DateTime(1998);
      expect(addNewArtefactBloc.validate(), "photo");

      addNewArtefactBloc.description = "test_description";
      addNewArtefactBloc.photo = File("assets/images/default_artefact.png");
      expect(addNewArtefactBloc.validate(), "");
    });

    // initiate a random family to link the member
    Family testFamily = Family(
      id: "0kURFq7NPggoS5srF4UIKfyZpbc2",
    );

    test("upload artefact", () async {
      addNewArtefactBloc.photo = File("assets/images/default_artefact.png");
      final newArtefact = await addNewArtefactBloc.addNewMember(testFamily);
      expect(newArtefact != null, true);
    });
  });
}
