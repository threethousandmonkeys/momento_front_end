import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/models/event.dart';
import 'package:momento/screens/add_new_page/add_new_event_page.dart';
import 'package:provider/provider.dart';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> with AutomaticKeepAliveClientMixin {
  ProfileBloc _bloc;

  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<ProfileBloc>(context);
    }
    return StreamBuilder<List<Event>>(
        stream: _bloc.getEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Column(
                    children: snapshot.data.map((event) => Text(event.name)).toList(),
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
