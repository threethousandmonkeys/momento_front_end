import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'form_text_field.dart';

class FormDateField extends StatefulWidget {
  final String title;
  final DateTime initialDateTime;
  final Function onChange;
  final DateTime firstDate;
  final DateTime lastDate;
  final TextEditingController controller;
  FormDateField({
    @required this.title,
    this.initialDateTime,
    this.onChange,
    this.firstDate,
    this.lastDate,
    this.controller,
  });
  @override
  _FormDateFieldState createState() => _FormDateFieldState();
}

class _FormDateFieldState extends State<FormDateField> {
  DateTime _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.initialDateTime ?? DateTime.now();
    widget.controller.text =
        widget.initialDateTime != null ? widget.initialDateTime.toString().split(" ")[0] : "N/A";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectDate(context),
      child: FormTextField(
        title: widget.title,
        enabled: false,
        controller: widget.controller,
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime initialDate = _selectedDate ?? widget.lastDate ?? DateTime.now();
    DateTime firstDate = widget.firstDate ?? DateTime(1000);
    DateTime lastDate = widget.lastDate ?? DateTime.now();

    if (Platform.isIOS) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: initialDate,
              minimumYear: firstDate.year,
              maximumYear: lastDate.year,
              onDateTimeChanged: (DateTime picked) {
                _updateSelected(picked);
              },
            ),
          );
        },
      );
    } else {
      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
      _updateSelected(picked);
    }
  }

  void _updateSelected(DateTime picked) {
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      // keep only date, discard time
      widget.controller.text = _selectedDate.toString().split(" ")[0];
      widget.onChange(picked);
    }
  }
}
