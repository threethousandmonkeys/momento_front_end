import 'package:flutter/material.dart';
import 'package:momento/bloc/time_line_bloc.dart';
import 'package:momento/models/event.dart';
import 'package:momento/models/family.dart';
import 'package:momento/models/member.dart';
import 'package:momento/screens/add_new_page/add_new_event_page.dart';

class TimeLine extends StatefulWidget {
  final Family family;
  final List<Member> members;
  TimeLine(this.family, this.members);
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> with AutomaticKeepAliveClientMixin {
  final _bloc = TimeLineBloc();

  @override
  void initState() {
    _bloc.updateEvents(widget.family);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNewEventPage(widget.family, widget.members),
                        ),
                      );
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
