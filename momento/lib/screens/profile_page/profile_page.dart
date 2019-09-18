import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'family_tree.dart';
import 'artefact_gallery.dart';
import 'package:provider/provider.dart';
import 'package:momento/services/auth_service.dart';
import 'package:momento/models/family.dart';
import 'package:momento/screens/signin_page/signin_page.dart';
import 'package:momento/components/slide_down_route.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  Family family;

  TabController _tabController;
  int _tabIndex = 0;
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

  void _handleTabChange() {
    setState(() {
      _tabIndex = _tabController.index;
    });
  }

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
                          image: AssetImage('assets/images/test_family_profile.jpg'),
                        ),
                ),
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
            Container(
              height: _tabIndex == 1 ? (10 / 3).ceil() * (width - (10 / 3).floor()) / 3 : width,
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
