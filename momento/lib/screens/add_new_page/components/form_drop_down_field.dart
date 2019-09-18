import 'package:flutter/material.dart';

class FormDropDownField extends StatefulWidget {
  List<DropdownMenuItem> dropdownMenuItems;
  String title;
  FormDropDownField(String title, List items) {
    dropdownMenuItems = items
        .map((value) => DropdownMenuItem(
              child: Text(value),
              value: value,
            ))
        .toList();
    this.title = title;
  }
  @override
  _FormDropDownFieldState createState() => _FormDropDownFieldState();
}

class _FormDropDownFieldState extends State<FormDropDownField> {
  String selected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text(
              widget.title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          DropdownButtonFormField(
            onChanged: (value) {
              setState(() {
                selected = value;
              });
            },
            value: selected,
            items: widget.dropdownMenuItems,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
