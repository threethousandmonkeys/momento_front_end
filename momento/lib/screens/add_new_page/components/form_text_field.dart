import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String title;
  final int maxLines;
  final TextEditingController controller;
  final bool enabled;
  FormTextField({
    @required this.title,
    this.maxLines = 1,
    this.controller,
    this.enabled = true,
  });
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
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextField(
            enabled: enabled,
            controller: controller,
            keyboardType: TextInputType.multiline,
            maxLines: maxLines,
            style: TextStyle(fontSize: 12.0),
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
