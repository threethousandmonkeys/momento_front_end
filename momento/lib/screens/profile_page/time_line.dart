import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/event.dart';
import 'package:momento/screens/form_pages/add_new_event_page.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine>
    with AutomaticKeepAliveClientMixin {
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

  List<TimelineModel> createTimelineModels(List<Event> events) {
    TimelineItemPosition position = TimelineItemPosition.right;

    events.sort((a, b) => a.date.compareTo(b.date));
    List<TimelineModel> timelineModels = [];
    for (var i = 0; i < events.length; i++) {
      timelineModels.add(TimelineModel(
          GestureDetector(
            onTap: () async {
              final updatedArtefact = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddNewEventPage(_bloc.family, _bloc.getLatestMembers),
                ),
              );
              if (updatedArtefact != null) {
                _bloc.updateArtefact(updatedArtefact);
              }
            },
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/loading_image.gif",
              image: events[i].thumbnail ?? events[i].photo,
              fit: BoxFit.cover,
            ),
          ),
          position: position,
          iconBackground: Colors.redAccent,
          icon: Icon(Icons.star)));
      if (position == TimelineItemPosition.right) {
        position = TimelineItemPosition.left;
      } else {
        position = TimelineItemPosition.right;
      }
    }
    return timelineModels;
  }

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
//            return Timeline(children: items, position: TimelinePosition.Center);
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      final newEvent = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewEventPage(
                              _bloc.family, _bloc.getLatestMembers),
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
                  Flexible(
                    child: Timeline(
                        children: createTimelineModels(snapshot.data),
                        position: TimelinePosition.Center),
                  ),
                ],
              ),
//              child: Column(
//                children: <Widget>[
//                  Column(
//                    children:
//                        snapshot.data.map((event) => Text(event.name)).toList(),
//                  ),
//                  GestureDetector(
//                    onTap: () async {
//                      final newEvent = await Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                          builder: (context) => AddNewEventPage(
//                              _bloc.family, _bloc.getLatestMembers),
//                        ),
//                      );
//                      if (newEvent != null) {
//                        _bloc.addEvent(newEvent);
//                      }
//                    },
//                    child: Icon(
//                      Icons.add_circle_outline,
//                      size: 50,
//                    ),
//                  ),
//                ],
//              ),
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
