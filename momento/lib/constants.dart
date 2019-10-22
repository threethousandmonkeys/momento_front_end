import 'package:flutter/material.dart';

const kGoldenRatio = 0.61803398875;

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

const kDividerRatio = 0.9;

const Color loginGradientStart = Color(0xFFF8EBD8);
const Color loginGradientEnd = Color(0xFF965454);

const kLoginDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      loginGradientStart,
      loginGradientEnd,
    ],
    begin: FractionalOffset(0.0, 0.0),
    end: FractionalOffset(1.0, 1.0),
    tileMode: TileMode.clamp,
  ),
);

const kDarkRedMorandi = Color(0xFF421910);

/// color name: unbleached silk (white-pink)
const kThemeColor = Color(0xFFFFDFCC);

/// color name: redbrick (dark red)
const kTitleColor = Color(0xFFFAFAFA);

const kHeaderColor = Color(0xFF5A0C21);

/// color name: space cadet (navy blue)
const kMainTextColor = Color(0xFF421910);
