import 'package:flutter/material.dart';
import 'package:momento/bloc/profile_bloc.dart';
import 'package:momento/screens/profile_page/profile_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      builder: (_) => ProfileBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: ProfilePage(),
      ),
    );
  }
}
