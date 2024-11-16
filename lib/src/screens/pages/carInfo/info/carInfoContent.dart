import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButtonAction.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class CarInfoContent extends StatelessWidget {

  CarInfo? car;
  String? originPage;

  CarInfoContent(this.car, this.originPage, {super.key});

  @override
  Widget build(BuildContext context) {
    print('CarInfo: ${car?.toJson()}');
    print(originPage);
    return Stack(
      children: [
        _headerCar(context),
        CustomIconBack(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
          onPressed: () {
            print(originPage);
            if (originPage == '/driver/0') {
              context.go('/driver/0');
              print('Driver: ${ModalRoute.of(context)?.settings.name}');
            } else if (originPage == '/driver/0/car/list') {
              context.pop();
              print('CarList: ${ModalRoute.of(context)?.settings.name}');
            } else if (originPage == '/passenger/0') {
              context.go('/driver/0');
              print('Passenger: ${ModalRoute.of(context)?.settings.name}');
            } else {
              context.pop();
              print('Pop: ${ModalRoute.of(context)?.settings.name}');
            }
          },
        ),        

        Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 26
          ),
          child: Column(
            children: [
              _cardCarInfo(context),
              _cardCarData(context),

              const Spacer(),
              CustomButtonAction(text: 'EDITAR VEHÍCULO', icon: Icons.edit, 
                onTapFunction: () {
                  // Navigator.pushNamed(context, '/car/update', arguments: car);
                  context.push('/car/list/update', extra: car);
                }
              ),
              CustomButtonAction(text: 'ELIMINAR VEHÍCULO', icon: Icons.delete_outline_rounded, 
                onTapFunction: () {},
                colorTop: const Color(0xFF6D0000),
                colorBottom: const Color(0xFFD20000),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCar(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
      height: MediaQuery.of(context).size.height * 0.33,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 64, 52), // Top color
            Color(0xFF00A48B), // Bottom color
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Text(
        'VEHÍCULO',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
      ),
    );
  }

  Widget _cardCarInfo(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 150),
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.white,
        child: Column(
          children: [
            Container(
              height: 160,
              margin: const EdgeInsets.only(top: 30, bottom: 15),
              child: Image.asset(
                'lib/assets/img/car_logo.jpg',
                fit: BoxFit.cover,
              ) 
            ),
            Text(
              '${car?.brand} - ${car?.model}' ?? 'Marca y Modelo',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardCarData(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35, top: 10),
      width: MediaQuery.of(context).size.width,
      child: IntrinsicHeight(
        child: Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patente: ${car?.patent}' ?? 'Patente',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Año: ${car?.year.toString()}' ?? 'Año',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 8),
                // Text(
                //   'Asientos: ${car?.seats.toString()}' ?? 'Asientos',
                //   style: TextStyle(
                //     color: Colors.grey[900],
                //     fontSize: 16
                //   ),
                // ),
                const SizedBox(height: 8),
                Text(
                  'Color: ${car?.color}' ?? 'color',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cedula Verde: ${car?.nroGreenCard.toString()}' ?? 'Cedula Verde',
                  style: TextStyle(
                    color: Colors.grey[900],
                    fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}