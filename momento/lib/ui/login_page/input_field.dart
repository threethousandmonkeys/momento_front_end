import 'package:flutter/material.dart';
import 'package:momento/constants.dart';

class InputField extends StatefulWidget {
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  double textFieldHeight;
  Function onChange;
  IconData icon;
  String hintText;
  GestureDetector suffix;
  _InputFieldState({
    @required this.textFieldHeight,
    @required this.onChange,
    @required this.icon,
    @required this.hintText,
    this.suffix,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: textFieldHeight,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: TextField(
          onChanged: onChange,
          keyboardType: TextInputType.emailAddress,
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

class InputTextField extends StatelessWidget {
  const InputTextField({
    @required this.textFieldHeight,
    @required this.onChange,
    @required this.icon,
    @required this.hintText,
    this.suffix,
  });

  final double textFieldHeight;
  final Function onChange;
  final IconData icon;
  final String hintText;
  final GestureDetector suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: textFieldHeight,
      child: Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: TextField(
          onChanged: onChange,
          keyboardType: TextInputType.emailAddress,
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
