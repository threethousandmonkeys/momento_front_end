import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'constants.dart';

class FormTextField extends StatefulWidget {
  final String title;
  final int maxLines;
  final bool enabled;
  final bool invalid;
  final Function onChanged;
  final Function onTap;
  final TextEditingController controller;
  final Widget suffix;
  FormTextField({
    @required this.title,
    this.maxLines = 1,
    this.enabled = true,
    this.onTap,
    this.invalid = false,
    this.onChanged,
    this.controller,
    this.suffix,
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
            onTap: widget.onTap,
            android: (_) => MaterialTextFieldData(
              decoration: InputDecoration(
                filled: true,
                fillColor: widget.invalid ? Colors.transparent : Colors.white,
                border: OutlineInputBorder(),
                contentPadding: kFormInputPadding,
                suffixIcon: widget.suffix,
              ),
            ),
            ios: (_) => CupertinoTextFieldData(
              padding: kFormInputPadding,
              suffix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: widget.suffix,
              ),
              decoration: BoxDecoration(
                color: widget.invalid ? Colors.transparent : Colors.white,
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
