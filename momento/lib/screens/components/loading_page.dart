import 'package:flutter/material.dart';

import '../../constants.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kBackgroundDecoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Image(
            image: AssetImage(
              'assets/images/loading.gif',
            ),
          ),
        ),
      ),
    );
  }
}
