import 'package:flutter/material.dart';

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
                selectedValue = value;
              });
              widget.onChanged(widget.items[value]);
            },
            value: selectedValue,
            items: widget.items.keys
                .map((key) => DropdownMenuItem(
                      value: key,
                      child: Text(key),
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
