import 'package:flutter/material.dart';
import 'constants.dart';

class FormTextField extends StatefulWidget {
  final String title;
  final int maxLines;
  final bool enabled;
  final Function onChanged;
  final TextEditingController controller;
  FormTextField({
    @required this.title,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.controller,
  });

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kFormFieldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: kFormTitlePadding,
            child: Text(
              widget.title,
              style: kFormTitleStyle,
            ),
          ),
          TextField(
            onChanged: widget.onChanged,
            enabled: widget.enabled,
            controller: widget.controller,
            keyboardType: TextInputType.multiline,
            maxLines: widget.maxLines,
            style: kFormTextFont,
            decoration: kFormInputDecoration,
          ),
        ],
      ),
    );
  }
}
