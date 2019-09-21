import 'package:flutter/material.dart';
import 'form_text_field.dart';

class FormDateField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final Function onChange;
  final DateTime firstDate;
  FormDateField({
    this.title,
    this.controller,
    this.onChange,
    this.firstDate,
  });
  @override
  _FormDateFieldState createState() => _FormDateFieldState();
}

class _FormDateFieldState extends State<FormDateField> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: widget.firstDate ?? DateTime(1000, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        widget.controller.text = selectedDate.toString().split(" ")[0];
        widget.onChange(picked);
      });
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
}
