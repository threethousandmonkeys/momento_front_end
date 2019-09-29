import 'package:flutter/material.dart';

class SnackBarService {
  /// customize the bar appear at the bottom of the screen <pop-up message>
  void showInSnackBar(GlobalKey<ScaffoldState> key, String value) {
    key.currentState?.removeCurrentSnackBar();
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold",
          ),
        ),
        backgroundColor: Color(0xFF9E8C81),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
