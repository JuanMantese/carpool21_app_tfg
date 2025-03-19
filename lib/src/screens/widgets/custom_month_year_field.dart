import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Custom Cupertino Input with Month and Year
class CustomMonthYearInput extends StatefulWidget {
  final Function(String text) onChanged;
  final String text;
  final String? initialValue;
  final EdgeInsetsGeometry padding;
  final String? Function(String?)? validator;

  const CustomMonthYearInput({
    super.key,
    required this.onChanged,
    required this.text,
    this.initialValue,
    this.padding = const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    this.validator,
  });

  @override
  State<CustomMonthYearInput> createState() => _CustomMonthYearInputState();
}

class _CustomMonthYearInputState extends State<CustomMonthYearInput> {
  final TextEditingController _controller = TextEditingController();
  final DateFormat _monthYearFormat = DateFormat('MM/yyyy');
  DateTime? _currentDate;

  List<String> months = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  List<int> years = List.generate(21, (index) => DateTime.now().year + index);

  int? selectedMonth;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue != '') {
      _controller.text = widget.initialValue!;
      _currentDate = _monthYearFormat.parse(widget.initialValue!);
    } else {
      _currentDate = DateTime.now();
    }
    selectedMonth = _currentDate?.month ?? 1;
    selectedYear = _currentDate?.year ?? DateTime.now().year;
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300, // Altura del modal
          child: Column(
            children: [
              // Fila superior con el texto
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Picker para el mes
              Row(
                children: [
                  // Picker para el mes
                  Expanded(
                    child: SizedBox(
                      height: 160,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: selectedMonth! - 1),
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedMonth = index + 1; // Mes basado en índice
                          });
                        },
                        children: List.generate(months.length, (index) {
                          return Center(
                            child: Text(months[index]),
                          );
                        }),
                      ),
                    ),
                  ),
                  // Picker para el año
                  Expanded(
                    child: SizedBox(
                      height: 160,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: 0
                        ),
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedYear = years[index];
                          });
                        },
                        children: List.generate(years.length, (index) {
                          return Center(
                            child: Text(years[index].toString()),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            
              // Botón de selección
              ElevatedButton(
                onPressed: () {
                  if (selectedMonth != null && selectedYear != null) {
                    _currentDate = DateTime(selectedYear!, selectedMonth!);
                    String formattedDate = DateFormat('MM/yyyy').format(_currentDate!);
                    print(formattedDate);
                    widget.onChanged(formattedDate);
                    setState(() {
                      _controller.text = formattedDate;
                    });
                    Navigator.pop(context);
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A98F),
                  side: const BorderSide(color: Color(0xFF00A98F)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: const Text(
                  'Seleccionar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String? _validateMonthYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Seleccione un mes y año';
    }
    try {
      _monthYearFormat.parseStrict(value);
      return null;
    } catch (_) {
      return 'Formato inválido (MM/YYYY)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectMonthYear(context),
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
          validator: widget.validator ?? _validateMonthYear,
        ),
      ),
    );
  }
}