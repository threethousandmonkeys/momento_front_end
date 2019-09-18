import 'package:flutter/material.dart';
import 'package:momento/screens/signin_page/signin_page.dart';
import 'package:momento/screens/profile_page/profile_page.dart';
import 'package:momento/services/auth_service.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print("auth state changed");
          final user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return Provider<User>.value(
              value: user,
              child: ProfilePage(),
            );
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
