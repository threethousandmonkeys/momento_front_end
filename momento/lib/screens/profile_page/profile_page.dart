import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:momento/constants.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/screens/components/loading_page.dart';
import 'package:momento/screens/components/ugly_button.dart';
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

  int _tabIndex = 0;
  TabController _tabController;
  Future<Null> _futureProfile;

  // initializations
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabChange);
    _futureProfile = _bloc.init(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      _tabIndex = _tabController.index;
    });
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        decoration: kBackgroundDecoration,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            StreamBuilder<List<String>>(
              stream: _bloc.getPhotos,
              initialData: [],
              builder: (context, snapshot) {
                return Container(
                  color: Colors.black,
                  child: CarouselSlider(
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    items: snapshot.data
                            .map(
                              (url) => FractionallySizedBox(
                                heightFactor: 1,
                                widthFactor: 1,
                                child: FadeInImage.assetNetwork(
                                  image: url,
                                  placeholder: "assets/images/loading_image.gif",
                                ),
                              ),
                            )
                            .toList() +
                        (snapshot.data.length == 0
                            ? []
                            : [
                                FractionallySizedBox(
                                  widthFactor: 1,
                                  heightFactor: 1,
                                  child: Container(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () async {
                                        File selected = await ImagePicker.pickImage(
                                            source: ImageSource.gallery);
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
                              ]),
                  ),
                );
              },
            ),

            /// family name display
            Center(
              child: Text(
                "The ${_bloc.name}s",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "WorkSansSemiBold",
                ),
              ),
            ),

            /// family description display
            StreamBuilder<String>(
              stream: _bloc.getDescription,
              initialData: "Loading...",
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: GestureDetector(
                    onTap: () async {
                      final newDescription = await showDialog(
                        context: context,
                        builder: (context) {
                          final descriptionController = TextEditingController();
                          descriptionController.text = snapshot.data;
                          return AlertDialog(
                            title: Text("Description:"),
                            content: TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 5,
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("CANCEL"),
                                onPressed: () {
                                  Navigator.pop(context, descriptionController.text);
                                },
                              ),
                              FlatButton(
                                child: Text("DONE"),
                                onPressed: () {
                                  Navigator.pop(context, descriptionController.text);
                                },
                              )
                            ],
                          );
                        },
                      );
                      if (newDescription != snapshot.data) {
                        _bloc.updateDescription(newDescription);
                      }
                    },
                    child: Text(
                      snapshot.data,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                );
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
              height: _tabIndex == 1
                  ? (width / 3) * (_bloc.family.artefacts.length / 3).ceil()
                  : height - 110,
              child: Provider<ProfileBloc>(
                builder: (_) => _bloc,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    FamilyTree(),
                    ArtefactGallery(),
                    TimeLine(),
                  ],
                ),
              ),
            ),

            /// logout button (testing only)
            UglyButton(
              text: "LOG OUT",
              height: 10,
              onPressed: () async {
                await _bloc.signOut();
                setState(() {
                  _futureProfile = _bloc.init(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
