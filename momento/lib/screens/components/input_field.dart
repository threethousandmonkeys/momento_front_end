import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:momento/constants.dart';
import 'package:flutter/cupertino.dart';

/// UI part for input field
class InputField extends StatelessWidget {
  InputField({
    this.controller,
    this.icon,
    this.hintText,
    this.inputType,
    this.suffix,
    this.bottomPadding,
    this.obscureText,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final TextInputType inputType;
  final GestureDetector suffix;
  final double bottomPadding;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 5,
            bottom: bottomPadding ?? 5,
          ),
          child: PlatformTextField(
            controller: controller,
            keyboardType: inputType,
            obscureText: obscureText ?? false,
            style: kTextFieldTextStyle,
            autocorrect: false,
            android: (_) => MaterialTextFieldData(
              decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  icon,
                  color: Colors.black,
                  size: 22.0,
                ),
                hintText: hintText,
                hintStyle: kHintTextStyle,
                suffixIcon: suffix,
              ),
            ),
            ios: (_) => CupertinoTextFieldData(
              prefix: Icon(
                icon,
                color: Colors.black,
                size: 22.0,
              ),
              suffix: suffix,
              placeholder: hintText,
              placeholderStyle: kHintTextStyle,
              decoration: BoxDecoration(
                border: Border.all(
                  style: BorderStyle.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
