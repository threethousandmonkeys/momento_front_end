import 'dart:io';

import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class AddNewEventBloc {
  final _familyRepository = FamilyRepository();
  final _eventRepository = EventRepository();
  final _cloudStorageService = CloudStorageService();

  String name = "";
  DateTime date;
  List<String> participants = [];
  String description = "";
  File photo;

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
    final fileName = "event_${DateTime.now().millisecondsSinceEpoch}";
    final url = await _cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);

    Event newEvent = Event(
      id: null,
      name: name,
      date: date,
      description: description,
      participants: participants,
      photo: url,
      thumbnail: null,
    );
    final eventId = await _eventRepository.createEvent(newEvent);
    await _familyRepository.addEvent(family, eventId);
    newEvent.id = eventId;
    return newEvent;
  }
}
