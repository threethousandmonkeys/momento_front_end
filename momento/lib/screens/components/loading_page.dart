import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image(
      image: AssetImage('assets/images/loading.gif'),
    ));
  }
}
