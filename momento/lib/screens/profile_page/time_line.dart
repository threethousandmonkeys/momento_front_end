import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/event.dart';
import 'package:momento/screens/form_pages//add_new_event_page.dart';
import 'package:momento/screens/form_pages/update_event_page.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline_model.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> with AutomaticKeepAliveClientMixin {
  ProfileBloc _bloc;

  List<TimelineModel> items = [
    TimelineModel(Placeholder(),
        position: TimelineItemPosition.left,
        iconBackground: Colors.redAccent,
        icon: Icon(Icons.blur_circular)),
    TimelineModel(Placeholder(),
        position: TimelineItemPosition.right,
        iconBackground: Colors.redAccent,
        icon: Icon(Icons.blur_circular)),
    TimelineModel(Placeholder(),
        position: TimelineItemPosition.left,
        iconBackground: Colors.redAccent,
        icon: Icon(Icons.blur_circular)),
  ];

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<ProfileBloc>(context);
    }
//    return Timeline(children: items, position: TimelinePosition.Center);
    return StreamBuilder<List<Event>>(
        stream: _bloc.getEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Column(
                    children: snapshot.data
                        .map((event) => GestureDetector(
                              onTap: () async {
                                final updatedEvent = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateEventPage(
                                        _bloc.family, event, _bloc.getLatestMembers),
                                  ),
                                );
                                if (updatedEvent != null) {
                                  _bloc.updateEvent(updatedEvent);
                                }
                              },
                              child: Text(
                                event.name,
                                style: TextStyle(fontSize: 40),
                              ),
                            ))
                        .toList(),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final newEvent = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddNewEventPage(_bloc.family, _bloc.getLatestMembers),
                        ),
                      );
                      if (newEvent != null) {
                        _bloc.addEvent(newEvent);
                      }
                    },
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 50,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold();
          }
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
