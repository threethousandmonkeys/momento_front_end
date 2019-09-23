import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momento/bloc/auth_bloc.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/screens/components/loading_page.dart';
import 'package:momento/screens/signin_page/sign_in_page.dart';
import 'package:momento/models/family.dart';
import 'package:momento/services/auth_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// ProfilePage: the widget of family profile page(home page)
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// _ProfilePageState: the state control of family profile page
class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  AuthBloc _authBloc = AuthBloc();
  ProfileBloc _profileBloc;
  Future<Null> _future;

  // initializations
  @override
  void initState() {
    _profileBloc = ProfileBloc(this);
    _future = _profileBloc.authenticate(context);
    super.initState();
  }

  /// build function of profile_page widget
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<Null>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildProfile(_profileBloc.family, width, height);
        } else {
          return LoadingPage();
        }
      },
    );
  }

  /// _buildProfile: build family profile display from the family details
  Widget _buildProfile(Family family, double width, double height) {
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            CarouselSlider(
              enableInfiniteScroll: false,
              autoPlay: false,
              viewportFraction: 1.0,
              items: _profileBloc.photos
                      .map((url) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList() +
                  [
                    Container(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
                          if (selected != null) {
                            await _profileBloc.uploadPhoto(selected);
                          }
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          size: 100,
                        ),
                      ),
                    ),
                  ],
            ),

            /// family name display
            Center(
              child: Text(
                "The ${family.name}s",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "WorkSansSemiBold",
                ),
              ),
            ),

            /// family description display
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 5.0,
              ),
              child: Text(
                family.description,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),

            /// edit family description button
            /// (not connected to editing page yet)
            MaterialButton(
              color: Color(0xFF9E8C81),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  "Edit Your Profile",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                print("edit");
              },
            ),

            /// logout button (testing only)
            MaterialButton(
              color: Color(0xFF9E8C81),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Text(
                  "LOG OUT",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () async {
                await _authBloc.signOut();
                setState(() {
                  _future = _profileBloc.authenticate(context);
                });
              },
            ),

            /// tab to switch among 3 main components
            Container(
              color: Colors.white24,
              child: TabBar(
                indicatorColor: Colors.grey,
                controller: _profileBloc.tabController,
                tabs: [
                  Tab(icon: Icon(Icons.people_outline)),
                  Tab(icon: Icon(Icons.photo_library)),
                  Tab(icon: Icon(Icons.timeline)),
                ],
              ),
            ),

            /// the display of 3 main components
            Container(
              height: height,
              child: TabBarView(
                controller: _profileBloc.tabController,
                children: _profileBloc.tabs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
