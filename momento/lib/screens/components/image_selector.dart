import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatefulWidget {
  final Function onChange;
  ImageSelector({this.onChange});
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File selected;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            final file = await ImagePicker.pickImage(source: ImageSource.gallery);
            setState(() {
              selected = file;
            });
            widget.onChange(file);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Upload Photo",
              ),
              Icon(Icons.photo_album),
            ],
          ),
        ),
        selected != null
            ? Image.file(
                selected,
                fit: BoxFit.fitWidth,
              )
            : Image.asset("assets/images/login_logo.png"),
      ],
    );
  }
}
