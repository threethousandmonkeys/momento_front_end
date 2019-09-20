import 'package:flutter/material.dart';

class FormDropDownField extends StatefulWidget {
  final List<String> items;
  final String title;
  final Function onChanged;
  FormDropDownField({this.title, this.items, this.onChanged});
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
              widget.onChanged(value);
            },
            value: selected,
            items: widget.items
                .map((value) => DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    ))
                .toList(),
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
