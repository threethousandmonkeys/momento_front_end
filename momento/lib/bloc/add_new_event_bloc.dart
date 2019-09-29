import 'dart:io';

import 'package:flutter/material.dart';
import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class AddNewEventBloc {
  final _familyRepository = FamilyRepository();
  final _eventRepository = EventRepository();
  final _cloudStorageService = CloudStorageService();

  final dateController = TextEditingController();

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
    return "";
  }

  Future<Family> addNewEvent(Family family) async {
    /// upload photo to cloud, return a retrieval path
    Event newEvent = Event(
      id: null,
      name: name,
      date: date,
      description: description,
    );
    final eventId = await _eventRepository.createEvent(newEvent);
    await _cloudStorageService.uploadPhotoAt("${family.id}/events/original/", eventId, photo);
    await _familyRepository.addEvent(family, eventId);
    family.events.add(eventId);
    return family;
  }
}
