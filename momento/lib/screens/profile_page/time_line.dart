import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/event.dart';
import 'package:momento/screens/components/lib/timeline.dart';
import 'package:momento/screens/components/lib/timeline_model.dart';
import 'package:momento/screens/detail_page/event_detail_page.dart';
import 'package:momento/screens/form_pages/add_new_event_page.dart';
import 'package:provider/provider.dart';

const kTextColor = Color(0xFF1F275F);

/// TimeLine: the widget of timeline
class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

/// _TimeLineState: the state control of timeline
class _TimeLineState extends State<TimeLine> with AutomaticKeepAliveClientMixin {
  ProfileBloc _bloc;

  ///create all the models need to display on the timeline based on a list
  ///of given events
  List<TimelineModel> _createTimelineModels(List<Event> events) {
    TimelineItemPosition position = TimelineItemPosition.right;
    int year = -1;
    TextStyle textStyle =
        TextStyle(fontFamily: 'WorkSansMedium', fontSize: 20, color: kTextColor);

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
      timelineModels.add(
        TimelineModel(
          Card(
            color: Color(0xFFFFFFFF),
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
                    padding: EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: ExtendedImage.network(
                        events[i].thumbnail ?? events[i].photo,
                        height: 150,
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                  ),
                  Text(
                    events[i].name,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          position: position,
          iconBackground: Color(0xFFB395D4),
          icon: Icon(Icons.date_range),
        ),
      );
      position = _changePosition(position);
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
  TimelineItemPosition _changePosition(TimelineItemPosition position) {
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
    return SafeArea(
      top: false,
      bottom: false,
      child: StreamBuilder<List<Event>>(
          stream: _bloc.getEvents,
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return CustomScrollView(
                key: const PageStorageKey<String>("timeline"),
                physics: ClampingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Timeline(
                      physics: NeverScrollableScrollPhysics(),
                      children: _createTimelineModels(snapshot.data),
                      position: TimelinePosition.Center,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () async {
                        final newEvent = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNewEventPage(
                              Provider.of<ProfileBloc>(context).family,
                              Provider.of<ProfileBloc>(context).getLatestMembers,
                            ),
                          ),
                        );
                        if (newEvent != null) {
                          Provider.of<ProfileBloc>(context).addEvent(newEvent);
                        }
                      },
                      child: Icon(
                        Icons.add,
                        size: 50,
                        color: kTextColor,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Scaffold();
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
