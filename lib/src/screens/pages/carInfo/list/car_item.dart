// ignore_for_file: avoid_print
import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CarItem extends StatelessWidget {

  final CarInfo car;

  const CarItem({
    super.key, 
    required this.car
  });

  @override
  Widget build(BuildContext context) {
    print('Car Info Item: ${car.toJson()}');
    return GestureDetector(
      onTap: () {
        context.push('/car/list/info', extra: {
          'idVehicle': car.idVehicle,
          'originPage': '/car/list',
        });
      },
      child: Card(
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        color: const Color(0xFFF9F9F9),
        surfaceTintColor: const Color(0xFFF9F9F9),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _carImageWithPatent(),
                  
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.brand,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Modelo: ${car.model}'),
                        Text('Año: ${car.year}'),
                        Text('Color: ${car.color}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Seguro ${car.insuranceType ?? ''}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF276EF1)
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_user_outlined, 
                              color: Color(0xFF276EF1)
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.teal),
                onPressed: () {
                  context.push('/car/list/update', extra: car);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carImageWithPatent() {
    return Column(
      children: [
        SizedBox(
          height: 100,
          width: 150,
          child: Image.asset(
            'lib/assets/img/car_logo-fillout.png',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          car.patent,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}