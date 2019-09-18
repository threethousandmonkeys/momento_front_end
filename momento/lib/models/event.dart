import 'package:cloud_firestore/cloud_firestore.dart';

/// a model to represent family, which store the name and description and email
class Event {
  String eventName;
  String eventParticipant;
  DateTime eventDate;

  Event({
    this.eventName,
    this.eventParticipant,
    this.eventDate
  });
}

Future<Event> parseEvent(String uid) async {
}
