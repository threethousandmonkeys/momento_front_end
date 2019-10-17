import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momento/constants.dart';
import 'package:momento/screens/form_pages/components/form_text_field.dart';

import 'constants.dart';

const double _kPickerItemHeight = 32.0;

class FormDropDownField extends StatefulWidget {
  final Map<String, dynamic> items;
  final String title;
  final Function onChanged;
  final String itemKey;
  final TextEditingController controller;
  FormDropDownField({
    this.title,
    this.items,
    this.onChanged,
    this.itemKey,
    this.controller,
  });
  @override
  _FormDropDownFieldState createState() => _FormDropDownFieldState();
}

class _FormDropDownFieldState extends State<FormDropDownField> {
  int selectedIndex = 0;
  String selectedValue;

  @override
  void initState() {
    if (widget.itemKey != "") {
      selectedValue = widget.itemKey;
      selectedIndex = widget.items.keys.toList().indexOf(widget.itemKey);
      widget.controller.text = widget.items[widget.itemKey];
    }
    super.initState();
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: MediaQuery.of(context).size.height * (1 - kGoldenRatio),
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: GestureDetector(
        // Blocks taps from propagating to the modal sheet and popping.
        onTap: () {},
        child: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    );
  }

  Widget _buildCupertinoPicker(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: selectedIndex);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (widget.items.isNotEmpty) {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoPicker(
                  scrollController: scrollController,
                  itemExtent: _kPickerItemHeight,
                  backgroundColor: CupertinoColors.white,
                  onSelectedItemChanged: (int index) {
                    if (mounted) {
                      setState(() => selectedIndex = index);
                      widget.controller.text = widget.items.values.toList()[selectedIndex];
                      widget.onChanged(widget.items.keys.toList()[selectedIndex]);
                    }
                  },
                  children: widget.items.keys
                      .map((key) => Center(
                            child: Text(
                              widget.items[key],
                            ),
                          ))
                      .toList(),
                ),
              );
            },
          );
        }
      },
      child: FormTextField(
        title: widget.title,
        enabled: false,
        controller: widget.controller,
        suffix: Icon(Icons.arrow_drop_down),
        invalid: widget.items.isEmpty,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildCupertinoPicker(context) : _buildMaterialPicker(context);
  }

  Widget _buildMaterialPicker(BuildContext context) {
    return Padding(
      padding: kFormFieldPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: kFormTitlePadding,
            child: Text(
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
                    child: Text(
                      widget.items[key],
                      style: kFormTextFont,
                    ),
                  ),
                )
                .toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: Platform.isIOS
                  ? OutlineInputBorder(borderRadius: BorderRadius.zero)
                  : OutlineInputBorder(),
              contentPadding: kFormInputPadding,
            ),
          ),
        ],
      ),
    );
  }
}
