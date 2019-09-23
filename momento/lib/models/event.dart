/// a model to represent family, which store the name and description and email
class Event {
  String eventName;
  String eventParticipant;
  DateTime eventDate;

  Event({this.eventName, this.eventParticipant, this.eventDate});

  static Future<Null> parseEvent(String uid) async {}
}
