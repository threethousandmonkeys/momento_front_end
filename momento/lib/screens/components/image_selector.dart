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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Upload Photo from",
              ),
              GestureDetector(
                onTap: () async {
                  final file = await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    setState(() {
                      selected = file;
                    });
                    widget.onChange(file);
                  }
                },
                child: Icon(Icons.photo_album),
              ),
              GestureDetector(
                onTap: () async {
                  final file = await ImagePicker.pickImage(source: ImageSource.camera);
                  if (file != null) {
                    setState(() {
                      selected = file;
                    });
                    widget.onChange(file);
                  }
                },
                child: Icon(Icons.camera_alt),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: MediaQuery.of(context).size.width / 4,
          backgroundImage:
              selected != null ? FileImage(selected) : AssetImage("assets/images/login_logo.png"),
        ),
      ],
    );
  }
}
