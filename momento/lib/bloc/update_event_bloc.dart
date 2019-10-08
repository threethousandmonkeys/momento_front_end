import 'dart:io';

import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

class UpdateEventBloc {
  final _eventRepository = EventRepository();
  final _cloudStorageService = CloudStorageService();

  Event event;

  UpdateEventBloc(Event oldEvent) {
    // a hacky way to clone (deep copy), amazing
    event = Event.parseEvent(oldEvent.id, oldEvent.serialize());
  }

  File photo;

  String validate() {
    if (event.name == "") {
      return "name";
    }
    if (event.participants.length == 0) {
      return "participants";
    }
    return "";
  }

  Future<Event> updateEvent(Family family) async {
    // update photo
    String photoUrl = event.photo;
    String thumbnailUrl = event.thumbnail;
    if (photo != null) {
      // delete old photo
      _cloudStorageService.deletePhoto(event.photo);
      if (event.thumbnail != null) {
        _cloudStorageService.deletePhoto(event.thumbnail);
      }
      // upload new photo
      final fileName = "event_${DateTime.now().millisecondsSinceEpoch}";
      photoUrl = await _cloudStorageService.uploadPhotoAt("${family.id}/", fileName, photo);
      thumbnailUrl = null;
    }

    Event newEvent = Event(
      id: event.id,
      name: event.name,
      date: event.date,
      participants: event.participants,
      description: event.description,
      photo: photoUrl,
      thumbnail: thumbnailUrl,
    );
    await _eventRepository.updateEvent(newEvent);
    return newEvent;
  }
}
