import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:momento/screens/form_pages/components/form_text_field.dart';

import 'constants.dart';

class FormDropDownField extends StatefulWidget {
  final Map<String, dynamic> items;
  final String title;
  final Function onChanged;
  final String itemKey;
  FormDropDownField({
    this.title,
    this.items,
    this.onChanged,
    this.itemKey,
  });
  @override
  _FormDropDownFieldState createState() => _FormDropDownFieldState();
}

class _FormDropDownFieldState extends State<FormDropDownField> {
  String selectedValue;

  @override
  void initState() {
    if (widget.itemKey != "") {
      selectedValue = widget.itemKey;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kFormFieldPadding,
      child: Platform.isIOS
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: FormTextField(
                title: "Gender",
                enabled: false,
                controller: TextEditingController()..text = selectedValue,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoPicker(
                      itemExtent: 32.0,
                      onSelectedItemChanged: (int index) {
                        final key = index.toString();
                        print(key);
                        setState(() {
                          selectedValue = widget.items[key];
                          widget.onChanged(selectedValue);
                        });
                      },
                      children: widget.items.keys
                          .map(
                            (key) => Center(
                              child: PlatformText(
                                widget.items[key],
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                );
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: kFormTitlePadding,
                  child: PlatformText(
                    widget.title,
                    style: kFormTitleStyle,
                  ),
                ),
                DropdownButtonFormField(
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                    widget.onChanged(value);
                  },
                  value: selectedValue,
                  items: widget.items.keys
                      .map(
                        (key) => DropdownMenuItem(
                          value: key,
                          child: PlatformText(
                            widget.items[key],
                            style: kFormTextFont,
                          ),
                        ),
                      )
                      .toList(),
                  decoration: kMaterialFormInputDecoration,
                ),
              ],
            ),
    );
  }
}
