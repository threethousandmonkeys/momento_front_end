import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/family_repository.dart';
import 'package:momento/services/cloud_storage_service.dart';
import 'package:momento/services/firestore_service.dart';

/// getting event entries from Firease cloud firestore and provide
/// it to the upper layers
class EventRepository {
  final _firestore = FirestoreService();
  final _cloudStorage = CloudStorageService();
  final _familyRepository = FamilyRepository();

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
      final thumbnail = await _cloudStorage.getPhoto("$familyId/event_$eventId@thumbnail");
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

  Future<Null> deleteEvent(Family family, Event event) async {
    if (event.photo != null) {
      _cloudStorage.deletePhoto(event.photo);
    }
    if (event.thumbnail != null) {
      _cloudStorage.deletePhoto(event.thumbnail);
    }
    await _firestore.deleteDocument("event", event.id);
    await _familyRepository.deleteEvent(family, event.id);
  }
}
