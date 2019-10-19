import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/repositories/event_repository.dart';
import 'package:momento/screens/components/entry.dart';
import 'package:momento/screens/detail_page/detail_page.dart';
import 'package:momento/screens/form_pages/update_event_page.dart';
import 'package:momento/screens/components/viewable_image.dart';
import 'package:momento/services/dialogs.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';

/// UI part for event detail pages
class EventDetailPage extends StatefulWidget {
  final Event event;
  EventDetailPage(this.event);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Event currentEvent;
  final _keyLoader = GlobalKey<State>();
  final _eventRepository = EventRepository();

  @override
  void initState() {
    currentEvent = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 2.7;
    return DetailPage(
      edit: () async {
        final updatedEvent = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateEventPage(
              currentEvent,
              Provider.of<ProfileBloc>(context).getLatestMembers,
            ),
          ),
        );
        if (updatedEvent != null) {
          currentEvent = updatedEvent;
          Provider.of<ProfileBloc>(context).updateEvent(updatedEvent);
        }
      },
      delete: () async {
        Dialogs.showLoadingDialog(context, _keyLoader);
        await _eventRepository.deleteEvent(
          Provider.of<ProfileBloc>(context).family,
          currentEvent,
        );
        Provider.of<ProfileBloc>(context).deleteEvent(currentEvent.id);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Navigator.pop(context);
      },
      content: <Widget>[
        ViewableImage(currentEvent.photo),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              currentEvent.name,
              minFontSize: 40,
              style: TextStyle(
                color: Color(0xFF6B5152),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width - width) * 0.15,
          ),
          child: Column(
            children: <Widget>[
              Entry(
                title: "Date",
                content: currentEvent.date.toString().split(' ')[0],
              ),
              Entry(
                title: "Description",
                content: currentEvent.description,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
