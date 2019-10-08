import 'package:flutter/material.dart';

import 'constants.dart';

class FormDropDownField extends StatefulWidget {
  final Map<String, dynamic> items;
  final String title;
  final Function onChanged;
  final String itemKey;
  FormDropDownField({
    this.title,
    this.items,
    this.onChanged,
    this.itemKey,
  });
  @override
  _FormDropDownFieldState createState() => _FormDropDownFieldState();
}

class _FormDropDownFieldState extends State<FormDropDownField> {
  String selectedValue;

  @override
  void initState() {
    if (widget.itemKey != "") {
      selectedValue = widget.itemKey;
    }
    super.initState();
  }

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
              widget.onChanged(value);
            },
            value: selectedValue,
            items: widget.items.keys
                .map(
                  (key) => DropdownMenuItem(
                    value: key,
                    child: Text(
                      widget.items[key],
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
