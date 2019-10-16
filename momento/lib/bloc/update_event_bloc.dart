import 'dart:io';

import 'package:momento/models/event.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';

/** Business logical：
 *     For updating new event. Including checking the
 *     validity and  upload the new photos into
 *     cloud
 **/

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

  Future<Event> updateEvent(String familyId) async {
    // update photo
    if (photo != null) {
      // delete old photo
      _cloudStorageService.deletePhoto(event.photo);
      if (event.thumbnail != null) {
        _cloudStorageService.deletePhoto(event.thumbnail);
      }
      // upload new photo
      final fileName = "event_${DateTime.now().millisecondsSinceEpoch}";
      event.photo = await _cloudStorageService.uploadPhotoAt("$familyId/", fileName, photo);
      event.thumbnail = null;
    }

    await _eventRepository.updateEvent(event);
    return event;
  }
}
