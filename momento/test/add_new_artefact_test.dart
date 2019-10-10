import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:momento/bloc/add_new_artefact_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/artefact_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class MockArtefactRepository extends Mock implements ArtefactRepository {}

class MockCloudStorageService extends Mock implements CloudStorageService {}

class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  AddNewArtefactBloc addNewArtefactBloc;

  setUp(() {
    addNewArtefactBloc = AddNewArtefactBloc(
      MockArtefactRepository(),
      MockCloudStorageService(),
      MockFamilyRepository(),
    );
  });

  test("intial page state", () {
    expect(addNewArtefactBloc.name, "");
    expect(addNewArtefactBloc.dateCreated, null);
    expect(addNewArtefactBloc.originalOwner, null);
    expect(addNewArtefactBloc.currentOwner, null);
    expect(addNewArtefactBloc.description, "");
    expect(addNewArtefactBloc.photo, null);
  });

  group("add artefact", () {
    test("input artefact", () {
      expect(addNewArtefactBloc.validate(), "name");
      addNewArtefactBloc.name = "test";
      expect(addNewArtefactBloc.validate(), "current owner");
      addNewArtefactBloc.dateCreated = DateTime(1998);
      addNewArtefactBloc.originalOwner = "test_original_owner_id";
      addNewArtefactBloc.currentOwner = "test_current_owner_id";
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
      final newArtefact = await addNewArtefactBloc.addNewArtefact(testFamily);
      expect(newArtefact != null, true);
    });
  });
}
