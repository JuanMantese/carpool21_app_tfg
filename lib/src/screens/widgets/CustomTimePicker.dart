import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final String labelText;
  final IconData icon;
  final Function(String) onTimeChanged;
  final TimeOfDay? initialTime;
  final EdgeInsetsGeometry padding;

  CustomTimePicker({
    super.key,
    required this.labelText,
    this.icon = Icons.access_time,
    required this.onTimeChanged,
    this.initialTime,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;

        // Convert the selected TimeOfDay to DateTime / hora seleccionada con la fecha actual
        final now = DateTime.now();
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );

        // If selected time is greater than the current time, set the date to the next day
        final adjustedDateTime = selectedDateTime.isAfter(now)
            ? selectedDateTime
            : selectedDateTime.add(const Duration(days: 1));

        // Convert to UTC and then to ISO 8601 format
        // final utcDateTime = adjustedDateTime.toUtc(); // UTC
        final utcMinus3DateTime = adjustedDateTime.subtract(const Duration(hours: 0)); // UTC-3
        final iso8601String = utcMinus3DateTime.toIso8601String();

        widget.onTimeChanged(iso8601String);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          labelText: widget.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: Icon(widget.icon),
        ),
        child: Text(
          selectedTime != null ? selectedTime!.format(context) : '',
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}