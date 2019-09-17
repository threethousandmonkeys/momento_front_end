import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'family_tree.dart';
import 'artefact_gallery.dart';
import 'package:provider/provider.dart';
import 'package:momento/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<Widget> _tabs = [
    FamilyTree(),
    ArtefactGallery(),
    FamilyTree(),
  ];
  int _tabIndex = 0;

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenWidth * 9 / 16,
                  child: Image(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/test_family_profile.jpg'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenWidth * 9 / 16 - 20),
                  child: Text(
                    "The SpongeBobs",
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
                "\"Who lives in a pineapple under the sea\nAbsorbent and yellow and porous is he\nIf nautical nonsense be something you wish\nThen drop on the deck and flop like a fish\"",
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
              height: _tabIndex == 1
                  ? (10 / 3).ceil() * (screenWidth - (10 / 3).floor()) / 3
                  : screenHeight,
              child: TabBarView(
                controller: _tabController,
                children: _tabs,
              ),
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
          ],
        ),
      ),
    );
  }
}
