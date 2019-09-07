import 'package:flutter/material.dart';
import 'package:momento/theme/style.dart' as Theme;

const kTextFieldTextStyle = TextStyle(
  fontFamily: "WorkSansSemiBold",
  fontSize: 16.0,
  color: Colors.black,
);

const kHintTextStyle = TextStyle(
  fontFamily: "WorkSansSemiBold",
  fontSize: 17.0,
);

const kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20.0,
  fontFamily: "WorkSansBold",
);

const kWidthRatio = 0.7;

const kTextFieldPadding = EdgeInsets.only(
  top: 10.0,
  bottom: 10.0,
  left: 20.0,
  right: 20.0,
);

const kLoginPageRatios = [1, 2, 1, 5];

const kDividerRatio = 0.9;

const kBackgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
  colors: [
    Theme.Colors.loginGradientStart,
    Theme.Colors.loginGradientEnd,
  ],
  begin: FractionalOffset(0.0, 0.0),
  end: FractionalOffset(1.0, 1.0),
  tileMode: TileMode.clamp,
));
