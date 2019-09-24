import 'package:flutter/material.dart';

import 'constants.dart';

class FormDropDownField extends StatefulWidget {
  final Map<String, dynamic> items;
  final String title;
  final Function onChanged;
  FormDropDownField({this.title, this.items, this.onChanged});
  @override
  _FormDropDownFieldState createState() => _FormDropDownFieldState();
}

class _FormDropDownFieldState extends State<FormDropDownField> {
  String selectedValue;
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
          DropdownButtonFormField(
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged(widget.items[value]);
            },
            value: selectedValue,
            items: widget.items.keys
                .map(
                  (key) => DropdownMenuItem(
                    value: key,
                    child: Text(
                      key,
                      style: kFormTextFont,
                    ),
                  ),
                )
                .toList(),
            decoration: kFormInputDecoration,
          ),
        ],
      ),
    );
  }
}
