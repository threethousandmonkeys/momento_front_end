import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/event.dart';
import 'package:momento/screens/detail_page/event_detail_page.dart';
import 'package:momento/screens/form_pages/add_new_event_page.dart';
import 'package:provider/provider.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

/// TimeLine: the widget of timeline
class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

/// _TimeLineState: the state control of timeline
class _TimeLineState extends State<TimeLine>
    with AutomaticKeepAliveClientMixin {
  ProfileBloc _bloc;

  ///create all the models need to display on the timeline based on a list
  ///of given events
  List<TimelineModel> _createTimelineModels(List<Event> events) {
    TimelineItemPosition position = TimelineItemPosition.right;
    int year = -1;
    TextStyle textStyle = TextStyle(
        fontFamily: 'WorkSansMedium', fontSize: 20, color: Colors.brown[700]);

    // sort the events based on date
    if (events.isEmpty == false) {
      events.sort((a, b) => a.date.compareTo(b.date));
    }
    List<TimelineModel> timelineModels = [];

    for (var i = 0; i < events.length; i++) {
      // create an timeline item showing year before display all the
      // events happened in that year
      if (events[i].date.year != year) {
        year = events[i].date.year;
        timelineModels.add(
          TimelineModel(
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  year.toString(),
                  style: textStyle,
                ),
              ],
            ),
            position: TimelineItemPosition.left,
            iconBackground: Color(0xFF7CA9DF),
            icon: Icon(Icons.star),
          ),
        );
      }
      timelineModels.add(TimelineModel(
          Card(
            color: Color(0xFFFAFAFA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailPage(events[i]),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Text(
                    events[i].date.toString().split(' ')[0],
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: FadeInImage.assetNetwork(
                        height: 150,
                        placeholder: "assets/images/loading_image.gif",
                        image: events[i].thumbnail ?? events[i].photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    events[i].name,
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ),
          position: position,
          iconBackground: Color(0xFFB395D4),
          icon: Icon(Icons.date_range)));
      position = changePosition(position);
    }

    // create a timeline item showing "now" at the end of the timeline
    timelineModels.add(TimelineModel(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              "Now",
              style: textStyle,
            ),
          ],
        ),
        position: TimelineItemPosition.left,
        iconBackground: Color(0xFF7CA9DF),
        icon: Icon(Icons.mood)));
    return timelineModels;
  }

  /// alternating the display position of timeline items
  TimelineItemPosition changePosition(TimelineItemPosition position) {
    if (position == TimelineItemPosition.right) {
      return (TimelineItemPosition.left);
    } else {
      return (TimelineItemPosition.right);
    }
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      physics: NeverScrollableScrollPhysics(),
                      children: _createTimelineModels(snapshot.data),
                      position: TimelinePosition.Center,
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
