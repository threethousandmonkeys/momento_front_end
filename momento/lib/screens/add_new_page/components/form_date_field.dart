import 'package:flutter/material.dart';
import 'form_text_field.dart';

class FormDateField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final Function onChange;
  FormDateField({
    this.title,
    this.controller,
    this.onChange,
  });
  @override
  _FormDateFieldState createState() => _FormDateFieldState();
}

class _FormDateFieldState extends State<FormDateField> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1000, 8),
      lastDate: DateTime(2101),
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
