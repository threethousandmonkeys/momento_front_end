import 'dart:math';

import 'package:momento/models/event.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/services/firestore_service.dart';

class EventRepository {
  final _firestore = FirestoreService();
  final _cloudStorage = CloudStorageService();

  Future<String> createEvent(String id, Event event) async {
    final eventId = await _firestore.createDocumentById(
      "event",
      id,
      event.serialize(),
    );
    return eventId;
  }

  Future<Event> getEventById(String familyId, String eventId) async {
    final jsonEvent = await _firestore.getDocument("event", eventId);
    final event = Event.parseEvent(eventId, jsonEvent);
    if (event.thumbnail == null) {
      final thumbnail = await _cloudStorage.getPhoto("$familyId/event_$eventId@thumbnail.jpg");
      if (thumbnail != null) {
        event.thumbnail = thumbnail;
        await updateEvent(event);
      }
    }
    return event;
  }

  Future<Null> updateEvent(Event event) async {
    await _firestore.updateDocument(
      "event",
      event.id,
      event.serialize(),
    );
  }
}
