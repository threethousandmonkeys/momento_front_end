import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'family_tree.dart';
import 'artefact_gallery.dart';
import 'package:provider/provider.dart';
import 'package:momento/services/auth_service.dart';
import 'package:momento/models/family.dart';

/// ProfilePage: the widget of family profile page(home page)
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// _ProfilePageState: the state control of family profile page
class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  /// family detailed data
  Family family;

  TabController _tabController;
  int _tabIndex = 0;

  /// 3 components under family profile page
  List<Widget> _tabs = [
    FamilyTree(),
    ArtefactGallery(),
    FamilyTree(),
  ];

  // initializations
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabChange);
  }

  // disposals
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// switching among 3 main components
  void _handleTabChange() {
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

  /// build function of profile_page widget
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    final user = Provider.of<User>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return family != null
        ? _buildProfile(family, width, height)
        : FutureBuilder(
            future: parseFamily(user.uid),
            builder: (BuildContext context, AsyncSnapshot<Family> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                family = snapshot.data;
                return _buildProfile(family, width, height);
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
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
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  width: width,
                  height: width * 9 / 16,
                  child: family == null
                      ? null
                      : Image(
                          fit: BoxFit.fitWidth,
                          image: AssetImage(
                              'assets/images/test_family_profile.jpg'),
                        ),
                ),

                /// family name display
                Container(
                  margin: EdgeInsets.only(top: width * 9 / 16 - 20),
                  child: Text(
                    family == null ? null : "The ${family.name}s",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: "WorkSansSemiBold",
                    ),
                  ),
                ),
              ],
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
                ;
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
              onPressed: () {
                Provider.of<AuthService>(context).signOut();
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
                  ? (10 / 3).ceil() * (width - (10 / 3).floor()) / 3
                  : width,
              child: TabBarView(
                controller: _tabController,
                children: _tabs,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
