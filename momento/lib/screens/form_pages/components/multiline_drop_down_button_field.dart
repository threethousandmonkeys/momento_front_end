import 'package:flutter/material.dart';

/// A convenience widget that wraps a [DropdownButton] in a [FormField].
/// Taken from:
/// https://gist.github.com/malviyaritesh/04b94f72c5c2047ea4bd06aaf0a99fc7
class MultilineDropdownButtonFormField<T> extends FormField<T> {
  /// Creates a [DropdownButton] widget wrapped in an [InputDecorator] and
  /// [FormField].
  ///
  /// The [DropdownButton] [items] parameters must not be null.
  MultilineDropdownButtonFormField({
    Key key,
    T value,
    @required List<DropdownMenuItem<T>> items,
    this.onChanged,
    InputDecoration decoration = const InputDecoration(),
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    Widget hint,
    bool isExpanded = false,
    bool isDense = true,
  }) : assert(decoration != null),
       assert(isExpanded != null),
       assert(isDense != null),
       super(
         key: key,
         onSaved: onSaved,
         initialValue: value,
         validator: validator,
         builder: (FormFieldState<T> field) {
           final InputDecoration effectiveDecoration = decoration
             .applyDefaults(Theme.of(field.context).inputDecorationTheme);
           return InputDecorator(
             decoration: effectiveDecoration.copyWith(errorText: field.errorText),
             isEmpty: value == null,
             child: DropdownButtonHideUnderline(
               child: DropdownButton<T>(
                 isExpanded: isExpanded,
                 isDense: isDense,
                 value: value,
                 items: items,
                 hint: hint,
                 onChanged: field.didChange,
               ),
             ),
           );
         }
       );

  /// Called when the user selects an item.
  final ValueChanged<T> onChanged;

  @override
  FormFieldState<T> createState() => _MultilineDropdownButtonFormFieldState<T>();
}

class _MultilineDropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  MultilineDropdownButtonFormField<T> get widget => super.widget;

  @override
  void didChange(T value) {
    super.didChange(value);
    if (widget.onChanged != null)
      widget.onChanged(value);
  }
}