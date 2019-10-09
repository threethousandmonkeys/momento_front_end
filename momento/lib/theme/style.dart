import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// the color theme of memento
class Colors {
  const Colors();
  static const Color loginGradientStart = const Color(0xFFFFFFFF);
  static const Color loginGradientEnd = const Color(0xFFFFFFFF);
//  static const Color loginGradientStart = const Color(0xFFDDCFB9);
//  static const Color loginGradientEnd = const Color(0xFFDB9A91);

  /// color transition
  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
