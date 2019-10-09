import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// the color theme of memento
class Colors {
  const Colors();
  static const Color backgroundGradientStart = const Color(0xFFFFFAF4);
  static const Color backgroundGradientEnd = const Color(0xFFECECEA);

  /// color transition
  static const primaryGradient = const LinearGradient(
    colors: const [backgroundGradientStart, backgroundGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const Color loginGradientStart = const Color(0xFFF8EBD8);
  static const Color loginGradientEnd = const Color(0xFF965454);
  static const loginGradient = const LinearGradient(
    colors: const [backgroundGradientStart, backgroundGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
