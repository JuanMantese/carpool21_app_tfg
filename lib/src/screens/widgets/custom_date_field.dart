import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CustomDateField extends StatefulWidget {
  final Function(String text) onChanged;
  final String text;
  final String? initialValue;
  final EdgeInsetsGeometry padding;
  final String? Function(String?)? validator;

  const CustomDateField({
    super.key,
    required this.onChanged,
    required this.text,
    this.initialValue,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    this.validator,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  final TextEditingController _controller = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = widget.initialValue!;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = _dateFormat.format(pickedDate);
      setState(() {
        _controller.text = formattedDate;
      });
      widget.onChanged(formattedDate);
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese una fecha';
    }
    try {
      _dateFormat.parseStrict(value);
      return null;
    } catch (_) {
      return 'Formato inválido (DD/MM/YYYY)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.text,
            labelStyle: const TextStyle(color: Color(0xFF006D59)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF006D59)),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF006D59)),
          ),
          validator: widget.validator ?? _validateDate,
        ),
      ),
    );
  }
}