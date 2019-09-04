import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'package:flutter/cupertino.dart';

class InputField extends StatelessWidget {
  InputField({
    this.onChange,
    this.icon,
    this.hintText,
    this.inputType,
    this.suffix,
    this.bottomPadding,
    this.obscureText,
  });

  final Function onChange;
  final IconData icon;
  final String hintText;
  final TextInputType inputType;
  final GestureDetector suffix;
  final double bottomPadding;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 5,
          bottom: bottomPadding ?? 5,
        ),
        child: TextField(
          onChanged: onChange,
          keyboardType: inputType,
          obscureText: obscureText ?? false,
          style: kTextFieldTextStyle,
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
      ),
    );
  }
}

class PasswordInputField extends InputField {
  PasswordInputField() {
    ;
  }
}
