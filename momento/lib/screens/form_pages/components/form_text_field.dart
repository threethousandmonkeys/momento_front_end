import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'constants.dart';

class FormTextField extends StatefulWidget {
  final String title;
  final int maxLines;
  final bool enabled;
  final Function onChanged;
  final TextEditingController controller;
  FormTextField({
    @required this.title,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.controller,
  });

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kFormFieldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: kFormTitlePadding,
            child: PlatformText(
              widget.title,
              style: kFormTitleStyle,
            ),
          ),
          PlatformTextField(
            onChanged: widget.onChanged,
            enabled: widget.enabled,
            controller: widget.controller,
            keyboardType: TextInputType.multiline,
            maxLines: widget.maxLines,
            style: kFormTextFont,
            android: (_) => MaterialTextFieldData(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                contentPadding: kFormInputPadding,
              ),
            ),
            ios: (_) => CupertinoTextFieldData(
              padding: kFormInputPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: CupertinoColors.inactiveGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
