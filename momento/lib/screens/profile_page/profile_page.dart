import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/constants.dart';
import 'package:momento/screens/components/loading_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:momento/screens/profile_page/artefact_gallery.dart';
import 'package:momento/screens/profile_page/family_tree.dart';
import 'package:momento/screens/profile_page/time_line.dart';

/// ProfilePage: the widget of family profile page(home page)
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// _ProfilePageState: the state control of family profile page
class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final _bloc = ProfileBloc();

  TabController _tabController;
  Future<Null> _futureProfile;

  // initializations
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _futureProfile = _bloc.init(context);
  }

  /// build function of profile_page widget
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Null>(
      future: _futureProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildProfile(context);
        } else {
          return LoadingPage();
        }
      },
    );
  }

  /// _buildProfile: build family profile display from the family details
  Widget _buildProfile(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            CarouselSlider(
              scrollPhysics: ClampingScrollPhysics(),
              enableInfiniteScroll: false,
              autoPlay: false,
              viewportFraction: 1.0,
              items: _bloc.photos
                      .map(
                        (url) => FractionallySizedBox(
                          heightFactor: 1,
                          widthFactor: 1,
                          child: Container(
                            child: FadeInImage.assetNetwork(
                              image: url,
                              placeholder: "assets/images/loading_image.gif",
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList() +
                  [
                    FractionallySizedBox(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: Container(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            File selected =
                                await ImagePicker.pickImage(source: ImageSource.gallery);
                            if (selected != null) {
                              await _bloc.uploadPhoto(selected);
                            }
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.purple,
                            size: 100,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
            ),

            /// family name display
            Center(
              child: Text(
                "The ${_bloc.family.name}s",
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
                _bloc.family.description,
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
                await _bloc.signOut();
                setState(() {
                  _futureProfile = _bloc.init(context);
                });
              },
            ),

            /// tab to switch among 3 main components
            Container(
              color: Colors.white24,
              child: TabBar(
                indicatorColor: Colors.grey,
                controller: _tabController,
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
                controller: _tabController,
                children: [
                  FamilyTree(_bloc.family, _bloc.members),
                  ArtefactGallery(_bloc.family, _bloc.members),
                  TimeLine(_bloc.family, _bloc.members),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
