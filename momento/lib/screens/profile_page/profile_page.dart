import 'dart:io';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:momento/constants.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/screens/profile_page/artefact_gallery.dart';
import 'package:momento/screens/profile_page/stemma.dart';
import 'package:momento/screens/profile_page/time_line.dart';
import 'package:momento/services/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

const kTabBarHeight = 46.0;

/// ProfilePage: the widget of family profile page(home page)
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// _ProfilePageState: the state control of family profile page
class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();

  TabController _tabController;
  Future<Null> _futureProfile;

  double _width;
  double _height;

  ProfileBloc _bloc;

  File selectedUpload;

  // initializations
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    super.initState();
  }

  // disposals
  @override
  void dispose() {
    _tabController.dispose();
    _bloc.close();
    super.dispose();
  }

  /// build function of profile_page widget
  @override
  Widget build(BuildContext context) {
    if (_bloc == null) {
      _bloc = Provider.of<ProfileBloc>(context);
      _futureProfile = _bloc.init(context);
    }
    // get device dimensions
    if (_width == null || _height == null) {
      _width = MediaQuery.of(context).size.width;
      _height = MediaQuery.of(context).size.height;
    }
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: FutureBuilder<Null>(
          future: _futureProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              double pinnedHeaderHeight =
                  MediaQuery.of(context).padding.top + kToolbarHeight + kTabBarHeight;
              return NestedScrollView(
                pinnedHeaderSliverHeightBuilder: () => pinnedHeaderHeight,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      elevation: 0.0,
                      backgroundColor: Color(0xFFBFBFBF),
                      expandedHeight: _height * (1 - kGoldenRatio),
                      actions: <Widget>[
                        IconButton(
                          onPressed: () async {
                            await _bloc.signOut();
                            _futureProfile = _bloc.init(context);
                          },
                          icon: Icon(
                            Icons.power,
                          ),
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.all(0),
                        title: Text(
                          "The ${_bloc.name}s",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Anton",
                          ),
                        ),
                        background: StreamBuilder<List<String>>(
                          stream: _bloc.getPhotos,
                          initialData: null,
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return Container();
                            } else {
                              return Container(
                                color: Colors.black,
                                height: _height * (1 - kGoldenRatio),
                                child: CarouselSlider(
                                  height: _height,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1.0,
                                  items: snapshot.data
                                          .map(
                                            (url) => FractionallySizedBox(
                                              heightFactor: 1,
                                              widthFactor: 1,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fitHeight,
                                                imageUrl: url,
                                                placeholder: (context, url) => SpinKitCircle(
                                                  color: Colors.purple,
                                                ),
                                                errorWidget: (context, url, error) =>
                                                    Icon(Icons.error),
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
                                              selectedUpload = await ImagePicker.pickImage(
                                                  source: ImageSource.gallery);
                                              if (selectedUpload != null) {
                                                setState(() {});
                                                Dialogs.showLoadingDialog(context, _keyLoader);
                                                await _bloc.uploadPhoto(selectedUpload);
                                                selectedUpload = null;
                                                Navigator.of(_keyLoader.currentContext,
                                                        rootNavigator: true)
                                                    .pop();
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: StreamBuilder<String>(
                        stream: _bloc.getDescription,
                        initialData: "",
                        builder: (context, snapshot) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
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
                                            Navigator.pop(context, null);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("DONE"),
                                          onPressed: () {
                                            if (descriptionController.text.trim() == "") {
                                              descriptionController.text =
                                                  "This family is too lazy to write any description.";
                                            }
                                            Navigator.pop(
                                                context, descriptionController.text.trim());
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                                if (newDescription != null && newDescription != snapshot.data) {
                                  _bloc.updateDescription(newDescription);
                                }
                              },
                              child: Text(
                                snapshot.data,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(fontSize: 18.0, fontFamily: "Lobster"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverTabBarDelegate(
                        child: Container(
                          color: Color(0xFFBFBFBF),
                          child: TabBar(
                            labelColor: Colors.black87,
                            unselectedLabelColor: Colors.black12,
                            indicatorColor: Colors.black,
                            controller: _tabController,
                            tabs: [
                              Tab(icon: Icon(Icons.people_outline)),
                              Tab(icon: Icon(Icons.photo_library)),
                              Tab(icon: Icon(Icons.timeline)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    Stemma(),
                    ArtefactGallery(),
                    TimeLine(),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  SliverTabBarDelegate({
    @required this.child,
  });
  @override
  double get minExtent => kTabBarHeight;
  @override
  double get maxExtent => kTabBarHeight;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) => false;
}
