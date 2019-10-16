import 'dart:io';

import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class AddNewEventBloc {
  final FamilyRepository familyRepository;
  final EventRepository eventRepository;
  final CloudStorageService cloudStorageService;

  AddNewEventBloc(
    this.eventRepository,
    this.familyRepository,
    this.cloudStorageService,
  );

  String name = "";
  DateTime date;
  List<String> participants = [];
  String description = "";
  File photo;

  // validations for testing
  String validate() {
    if (name == "") {
      return "name";
    }
    if (date == null) {
      return "date";
    }
    if (participants.length == 0) {
      return "participants";
    }
    if (photo == null) {
      return "photo";
    }
    return "";
  }

  /// upload photo to cloud, return a retrieval path
  Future<Event> addNewEvent(Family family) async {
    /// upload to cloud, wait for download url
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final url = await cloudStorageService.uploadPhotoAt("${family.id}/", "event_$id", photo);
    Event newEvent = Event(
      id: id,
      name: name,
      date: date,
      description: description,
      participants: participants,
      photo: url,
      thumbnail: null,
    );
    await eventRepository.createEvent(id, newEvent);
    await familyRepository.addEvent(family, id);
    return newEvent;
  }
}
