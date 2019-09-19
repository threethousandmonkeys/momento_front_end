import 'package:flutter/material.dart';
import 'package:momento/screens/signin_page/sign_in_page.dart';
import 'package:momento/screens/profile_page/profile_page.dart';
import 'package:momento/services/auth_service.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return StreamBuilder<AuthUser>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<AuthUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return Provider<AuthUser>.value(
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
