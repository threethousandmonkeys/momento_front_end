import 'package:flutter/material.dart';
import 'package:momento/screens/landing_page/landing_page.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      builder: (_) => AuthService(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage(),
      ),
    );
  }
}
