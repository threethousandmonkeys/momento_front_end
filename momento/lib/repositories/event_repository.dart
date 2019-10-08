import 'package:momento/models/event.dart';
import 'package:momento/services/firestore_service.dart';

class EventRepository {
  final _firestore = FirestoreService();

  Future<String> createEvent(Event event) async {
    final eventId = await _firestore.createDocument(
      collection: "event",
      jsonData: event.serialize(),
    );
    return eventId;
  }

  Future<Event> getEventById(String eventId) async {
    final jsonEvent = await _firestore.getDocument("event", eventId);
    return Event.parseEvent(eventId, jsonEvent);
  }

  Future<Null> updateEvent(Event event) async {
    await _firestore.updateDocument(
      collection: "event",
      documentId: event.id,
      newData: event.serialize(),
    );
  }
}
