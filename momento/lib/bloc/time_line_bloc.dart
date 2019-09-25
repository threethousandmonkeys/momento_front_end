import 'dart:async';

import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:rxdart/rxdart.dart';

class TimeLineBloc {
  final _eventRepository = EventRepository();

  final _eventsController = BehaviorSubject<List<Event>>();
  Function(List<Event>) get _setEvents => _eventsController.add;
  Stream<List<Event>> get getEvents => _eventsController.stream;

  Future<Null> updateEvents(Family family) async {
    List<Future<Event>> futureEvents =
        family.events.map((id) => _eventRepository.getEventById(id)).toList();
    List<Event> events = await Future.wait(futureEvents);
    _setEvents(events);
  }
}
