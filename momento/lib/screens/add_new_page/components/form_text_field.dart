import 'package:flutter/material.dart';
import 'constants.dart';

class FormTextField extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextEditingController controller;
  final bool enabled;
  final Function onChanged;
  FormTextField({
    @required this.title,
    this.maxLines = 1,
    this.controller,
    this.enabled = true,
    this.onChanged,
  });
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
              title,
              style: kFormTitleStyle,
            ),
          ),
          TextField(
            onChanged: onChanged,
            enabled: enabled,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            style: kFormTextFont,
            decoration: kFormInputDecoration,
          ),
        ],
      ),
    );
  }
}
