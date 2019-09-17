import 'package:flutter/material.dart';
import 'package:momento/screens/signin_page/signin_page.dart';
import 'package:momento/screens/profile_page/profile_page.dart';
import 'package:momento/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:momento/models/family.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return FutureBuilder<User>(
      future: auth.getCurrentUser(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final User user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return FutureBuilder(
                future: parseFamily(user.uid),
                builder: (BuildContext context, AsyncSnapshot<Family> snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.done) {
                    return Provider<Family>.value(
                      value: snapshot1.data,
                      child: ProfilePage(),
                    );
                  } else {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                });
          }
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
}
