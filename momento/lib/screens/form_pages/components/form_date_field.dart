import 'package:flutter/material.dart';
import 'form_text_field.dart';

class FormDateField extends StatefulWidget {
  final String title;
  final DateTime initialDateTime;
  final Function onChange;
  final DateTime firstDate;
  final TextEditingController controller;
  FormDateField({
    @required this.title,
    this.initialDateTime,
    this.onChange,
    this.firstDate,
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: widget.firstDate ?? DateTime(1000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        // keep only date, discard time
        widget.controller.text = _selectedDate.toString().split(" ")[0];
        widget.onChange(picked);
      });
  }
}
