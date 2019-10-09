import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants.dart';
import '../../models/event.dart';
import '../components/ugly_button.dart';

class EventDetailPage extends StatelessWidget {

  final Event event;
  EventDetailPage(this.event);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: event.photo,
              placeholder: (context, url) => SpinKitCircle(
                color: Colors.purple,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Text(event.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(event.date.toString().split(' ')[0]),
            Text("Description: " + event.description),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: UglyButton(
                text: "Edit Event",
                height: 10,
                onPressed: (){
                  print("aha");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
