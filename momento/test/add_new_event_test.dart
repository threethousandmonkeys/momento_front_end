import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:momento/bloc/add_new_event_bloc.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

/// mocks the repository and services
class MockEventRepository extends Mock implements EventRepository {}
class MockCloudStorageService extends Mock implements CloudStorageService {}
class MockFamilyRepository extends Mock implements FamilyRepository {}

void main() {
  AddNewEventBloc addNewEventBloc;

  /// set up the class to be tested
  setUp(() {
    addNewEventBloc = AddNewEventBloc(
      MockEventRepository(),
      MockFamilyRepository(),
      MockCloudStorageService(),
    );
  });

  test("Intial page state", () {
    expect(addNewEventBloc.name, "");
    expect(addNewEventBloc.date, null);
    expect(addNewEventBloc.participants, []);
    expect(addNewEventBloc.description, "");
    expect(addNewEventBloc.photo, null);
  });

  group("Add artefact:", () {
    test("Input artefact", () {
      expect(addNewEventBloc.validate(), "name");
      
      addNewEventBloc.name = "test";
      expect(addNewEventBloc.validate(), "date");
      
      addNewEventBloc.date = DateTime(1998);
      expect(addNewEventBloc.validate(), "participants");
      
      addNewEventBloc.participants = ["test_participant1", "test_participant2"];
      expect(addNewEventBloc.validate(), "photo");
      
      addNewEventBloc.description = "test_description";
      addNewEventBloc.photo = File("assets/images/default_artefact.jpg");
      expect(addNewEventBloc.validate(), "");
    });

    // initiate a random family to link the event
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
