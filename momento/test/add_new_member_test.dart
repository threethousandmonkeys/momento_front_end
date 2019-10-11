import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:momento/bloc/add_new_member_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/repositories/member_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class MockMemberRepository extends Mock implements MemberRepository {}

class MockCloudStorageService extends Mock implements CloudStorageService {}

class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  AddNewMemberBloc addNewArtefactBloc;

  setUp(() {
    addNewArtefactBloc = AddNewMemberBloc(
        MockMemberRepository(), MockCloudStorageService(), MockFamilyRepository(), []);
  });

  test("intial page state", () {
    expect(addNewArtefactBloc.firstName, "");
    expect(addNewArtefactBloc.middleName, "");
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
      expect(addNewArtefactBloc.validate(), "first name");
      addNewArtefactBloc.firstName = "test_first_name";
      expect(addNewArtefactBloc.validate(), "gender");
      addNewArtefactBloc.gender = "Male";
      expect(addNewArtefactBloc.validate(), "birthday");
      addNewArtefactBloc.birthday = DateTime(1998);
      expect(addNewArtefactBloc.validate(), "photo");
      addNewArtefactBloc.description = "test_description";
      addNewArtefactBloc.photo = File(
          "~/Users/sandytao520/Developer/momento_front_end/momento/assets/images/default_artefact.jpg");
      expect(addNewArtefactBloc.validate(), "");
    });

    Family testFamily = Family(
      id: "0kURFq7NPggoS5srF4UIKfyZpbc2",
    );

    test("upload artefact", () async {
      addNewArtefactBloc.photo = File("assets/images/default_artefact.jpg");
      final newArtefact = await addNewArtefactBloc.addNewMember(testFamily);
      expect(newArtefact != null, true);
    });
  });
}