import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Dialogs {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showPlatformDialog(
      context: context,
      androidBarrierDismissible: false,
      builder: (_) => PlatformAlertDialog(
        key: key,
        title: PlatformText("Please wait..."),
        content: SpinKitPumpingHeart(
          color: Colors.purple,
          size: 77,
        ),
      ),
    );
  }
}
