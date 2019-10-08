import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: key,
            backgroundColor: Colors.white,
            children: <Widget>[
              Center(
                child: Column(children: [
                  SizedBox(
                    height: 27,
                  ),
                  SpinKitPumpingHeart(
                    color: Colors.purple,
                    size: 128,
                  ),
                  SizedBox(
                    height: 27,
                  ),
                ]),
              )
            ],
          ),
        );
      },
    );
  }
}
