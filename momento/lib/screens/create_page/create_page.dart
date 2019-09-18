import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'package:momento/components/ugly_button.dart';

class CreatePage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Function onSubmit;

  CreatePage({
    @required this.title,
    @required this.children,
    @required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = MediaQuery.of(context).size.width * 0.1;
    return Scaffold(
      body: Container(
        decoration: kBackgroundDecoration,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ListView(
            children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50.0, bottom: 20),
                    child: Center(
                      child: Text(
                        "ADD NEW $title",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ] +
                children +
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      UglyButton(
                        text: "Cancel",
                        height: 10,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      UglyButton(
                        text: "Add",
                        height: 10,
                        onPressed: onSubmit,
                      )
                    ],
                  ),
                ],
          ),
        ),
      ),
    );
  }
}

class FormTextField extends StatelessWidget {
  final String title;
  final int maxLines;
  FormTextField({
    @required this.title,
    this.maxLines = 1,
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

class FormDropdownField extends StatefulWidget {
  final String title;
  final List items;
  FormDropdownField({
    @required this.title,
    @required this.items,
  });
  @override
  _FormDropdownFieldState createState() => _FormDropdownFieldState();
}

class _FormDropdownFieldState extends State<FormDropdownField> {
  int _value = 0;
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
              _value = value;
            },
            value: _value,
            items: widget.items.map((i) => DropdownMenuItem(child: i)).toList(),
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
