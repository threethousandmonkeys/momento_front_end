import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:momento/bloc/add_new_event_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class MockEventRepository extends Mock implements EventRepository {}

class MockCloudStorageService extends Mock implements CloudStorageService {}

class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  AddNewEventBloc addNewEventBloc;

  setUp(() {
    addNewEventBloc = AddNewEventBloc(
      MockEventRepository(),
      MockCloudStorageService(),
      MockFamilyRepository(),
    );
  });

  test("intial page state", () {
    expect(addNewEventBloc.name, "");
    expect(addNewEventBloc.date, null);
    expect(addNewEventBloc.participants, []);
    expect(addNewEventBloc.description, "");
    expect(addNewEventBloc.photo, null);
  });

  group("add artefact", () {
    test("input artefact", () {
      expect(addNewEventBloc.validate(), "name");
      addNewEventBloc.name = "test";
      expect(addNewEventBloc.validate(), "date");
      addNewEventBloc.date = DateTime(1998);
      expect(addNewEventBloc.validate(), "participants");
      addNewEventBloc.participants = ["test_participant1", "test_participant2"];
      expect(addNewEventBloc.validate(), "photo");
      addNewEventBloc.description = "test_description";
      addNewEventBloc.photo = File(
          "~/Users/sandytao520/Developer/momento_front_end/momento/assets/images/default_artefact.jpg");
      expect(addNewEventBloc.validate(), "");
    });

    Family testFamily = Family(
      id: "0kURFq7NPggoS5srF4UIKfyZpbc2",
    );

    test("upload artefact", () async {
      addNewEventBloc.photo = File("assets/images/default_artefact.jpg");
      final newArtefact = await addNewEventBloc.addNewEvent(testFamily);
      expect(newArtefact != null, true);
    });
  });
}
