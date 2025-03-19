import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdvancedFiltersModal extends StatefulWidget {
  final Function(String, String, TimeOfDay, TimeOfDay) onFilter;

  const AdvancedFiltersModal({required this.onFilter, super.key});

  @override
  _AdvancedFiltersModalState createState() => _AdvancedFiltersModalState();
}

class _AdvancedFiltersModalState extends State<AdvancedFiltersModal> {
  String originDestination = 'Origen/Destino';
  String campusKey = 'ALL';
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<String> originDestinationOptions = ['Origen/Destino', 'Origen', 'Destino'];

  List<Map<String, String>> campusOptions = [
    {'label': 'Sedes', 'key': 'ALL'},
    {'label': 'Campus Universitario', 'key': 'Campus Siglo 21'},
    {'label': 'Nueva Córdoba', 'key': 'Cede Nueva Córdoba'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '¡Filtros para buscar tu viaje!', 
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField(
            value: originDestination,
            items: originDestinationOptions.map((String option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                originDestination = value as String;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Origen/Destino',
            ),
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField(
            value: campusKey,
            items: campusOptions.map((campus) {
              return DropdownMenuItem(
                value: campus['key'],
                child: Text(campus['label']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                campusKey = value as String;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Sedes',
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Horario mínimo',
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        startTime = time;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: startTime != null ? startTime!.format(context) : '',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    labelText: 'Horario máximo',
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        endTime = time;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: endTime != null ? endTime!.format(context) : '',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Obtener el label correspondiente al key seleccionado
                  String selectedCampusKey = campusOptions.firstWhere(
                    (campus) => campus['key'] == campusKey,
                    orElse: () => {'key': 'ALL', 'label': 'Sedes'},
                  )['key']!;

                  widget.onFilter(
                    originDestination, 
                    selectedCampusKey,
                    startTime ?? const TimeOfDay(hour: 0, minute: 0), 
                    endTime ?? const TimeOfDay(hour: 23, minute: 59)
                  );
                  context.pop();
                },
                child: const Text('Filtrar'),
              ),
              OutlinedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}