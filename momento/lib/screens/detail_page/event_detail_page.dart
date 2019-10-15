import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/screens/form_pages/update_event_page.dart';
import 'package:momento/screens/components/viewable_image.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/event.dart';
import '../components/ugly_button.dart';

class EventDetailPage extends StatefulWidget {
  final Event event;
  EventDetailPage(this.event);

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Event currentEvent;
  @override
  void initState() {
    currentEvent = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            ViewableImage(currentEvent.photo),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Text(
                  currentEvent.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(currentEvent.date.toString().split(' ')[0]),
            Text("Description: " + currentEvent.description),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: UglyButton(
                text: "Edit Event",
                height: 10,
                onPressed: () async {
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
