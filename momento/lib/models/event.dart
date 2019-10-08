import 'package:cloud_firestore/cloud_firestore.dart';

/// a model to represent family, which store the name and description and email
class Event {
  String id;
  String name;
  DateTime date;
  List<String> participants;
  String description;
  String photo;
  String thumbnail;

  Event({
    this.id,
    this.name,
    this.date,
    this.participants,
    this.description,
    this.photo,
    this.thumbnail,
  });

  static Event parseEvent(String eventId, Map<String, dynamic> jsonEvent) {
    return Event(
      id: eventId,
      name: jsonEvent["name"],
      date: DateTime.fromMillisecondsSinceEpoch(jsonEvent["date"].seconds * 1000),
      participants: List<String>.from(jsonEvent["participants"]),
      description: jsonEvent["description"],
      photo: jsonEvent["photo"],
      thumbnail: jsonEvent["thumbnail"],
    );
  }

  Map<String, dynamic> serialize() {
    return {
      "name": this.name,
      "date": Timestamp((date.millisecondsSinceEpoch * 0.001).toInt(), 0),
      "participants": this.participants ?? [],
      "description": this.description,
      "photo": this.photo,
      "thumbnail": this.thumbnail,
    };
  }
}
