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
import 'package:momento/services/dialogs.dart';

/// ProfilePage: the widget of family profile page(home page)
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// _ProfilePageState: the state control of family profile page
class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final _bloc = ProfileBloc();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  int _tabIndex = 0;
  TabController _tabController;
  Future<Null> _futureProfile;

  double _width;
  double _height;
  double _tabHeight = 1000;

  // initializations
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabChange);
    _futureProfile = _bloc.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabIndex == 2) {
      _tabHeight = (_width / 3) * (_bloc.family.artefacts.length + 1 / 3).ceil();
    } else {
      _tabHeight = _height - 100;
    }
  }

  /// build function of profile_page widget
  @override
  Widget build(BuildContext context) {
    if (_width == null || _height == null) {
      _width = MediaQuery.of(context).size.width;
      _height = MediaQuery.of(context).size.height;
    }
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

  File selectedUpload;

  /// _buildProfile: build family profile display from the family details
  Widget _buildProfile(BuildContext context) {
    return Scaffold(
      body: Container(
        height: _height,
        decoration: kBackgroundDecoration,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            StreamBuilder<List<String>>(
              stream: _bloc.getPhotos,
              initialData: null,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    height: _height * (1 - kGoldenRatio),
                    color: Colors.black,
                  );
                }
                return Container(
                  color: Colors.black,
                  child: CarouselSlider(
                    height: _height * (1 - kGoldenRatio),
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
                        [
                          FractionallySizedBox(
                            widthFactor: 1,
                            heightFactor: 1,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                selectedUpload =
                                    await ImagePicker.pickImage(source: ImageSource.gallery);
                                if (selectedUpload != null) {
                                  setState(() {});
                                  try {
                                    Dialogs.showLoadingDialog(context, _keyLoader);
                                    await _bloc.uploadPhoto(selectedUpload);
                                    selectedUpload = null;
                                    Navigator.of(_keyLoader.currentContext, rootNavigator: true)
                                        .pop();
                                  } catch (error) {
                                    print(error);
                                  }
                                }
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Image(
                                    image: selectedUpload == null
                                        ? AssetImage("assets/images/login_logo.png")
                                        : FileImage(selectedUpload),
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: selectedUpload == null ? 100 : 0,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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
              height: _tabHeight,
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
