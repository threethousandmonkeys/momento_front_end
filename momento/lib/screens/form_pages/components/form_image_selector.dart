import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'constants.dart';

class ImageSelector extends StatefulWidget {
  final ImageProvider defaultImage;
  final Function onChange;
  final File selected;
  ImageSelector({
    @required this.defaultImage,
    this.onChange,
    this.selected,
  });
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  File currentSelected;
  @override
  void initState() {
    currentSelected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kFormFieldPadding,
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Upload Photo From",
                  style: kFormTitleStyle,
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        final file = await ImagePicker.pickImage(source: ImageSource.gallery);
                        if (file != null) {
                          widget.onChange(file);
                          setState(() {
                            currentSelected = file;
                          });
                        }
                      },
                      child: Icon(Icons.photo_album),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final file = await ImagePicker.pickImage(source: ImageSource.camera);
                        if (file != null) {
                          widget.onChange(file);
                          setState(() {
                            currentSelected = file;
                          });
                        }
                      },
                      child: Icon(Icons.camera_alt),
                    ),
                  ],
                )
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: MediaQuery.of(context).size.width / 4,
            backgroundImage:
                widget.selected != null ? FileImage(widget.selected) : widget.defaultImage,
          ),
        ],
      ),
    );
  }
}
