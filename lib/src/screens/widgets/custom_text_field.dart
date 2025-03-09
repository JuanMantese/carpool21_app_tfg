import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {

  Function(String text) onChanged;
  String? Function(String?)? validator;
  int? maxLength;
  String text;
  String? initialValue;
  TextInputType inputType;
  IconData icon;
  EdgeInsetsGeometry padding;

  // Variables para activar las expresiones regulares
  final bool isNumber;
  final bool isAlphabetic;

  CustomTextField({
    super.key, 
    required this.onChanged,
    this.validator,
    this.maxLength,
    required this.text,
    this.initialValue,
    required this.inputType,
    this.icon = Icons.visibility,
    this.padding = const EdgeInsets.only(top: 30, bottom: 30, right: 15, left: 15),
    this.isNumber = false,
    this.isAlphabetic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        onChanged: (text) {
          onChanged(text);
        },
        validator: validator,
        initialValue: initialValue,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: const TextStyle(color: Color(0xFF006D59)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF006D59)),
          ),
          counterText: "", // buildCounter to hide the counter maxLength
        ),
        keyboardType: inputType,
        inputFormatters: _getInputFormatters(),
      ),
    );
  }

  // Esta función se encarga de devolver los InputFormatters según las condiciones
  List<TextInputFormatter> _getInputFormatters() {
    List<TextInputFormatter> formatters = [];
    
    // Si isNumber es true, permite solo números
    if (isNumber) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^\d+$')));
    }
    
    // Si isAlphabetic es true, permite solo letras
    if (isAlphabetic) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')));
    }
    
    return formatters;
  }
}