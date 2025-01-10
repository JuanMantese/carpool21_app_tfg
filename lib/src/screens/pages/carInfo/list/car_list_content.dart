import 'package:carpool_21_app/src/domain/models/car_info.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/car_list_state.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/car_item.dart';
import 'package:carpool_21_app/src/screens/widgets/custom_icon_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CarListContent extends StatelessWidget {
  
  final CarListState state;
  final List<CarInfo>? carResponse;

  const CarListContent(
    this.state, 
    this.carResponse, 
    {super.key}
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [ 
          // Permite listar la informacion que viene dentro de una Lista
          Container(
            margin: const EdgeInsets.only(top: 100, bottom: 40),
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: ListView.builder(
              itemCount: carResponse?.length,
              itemBuilder: (context, index) {
                return CarItem(
                  car: carResponse![index]
                );
              },
            ),
          ),

          _headerVehicles(context),
          CustomIconBack(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
            onPressed: () {
              context.pop();
            },
          ),

          // Decoration
          const Positioned(
            top: 108,
            right: 108,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          const Positioned(
            top: 66,
            right: 90,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          const Positioned(
            top: 100,
            right: 76,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          const Positioned(
            top: 76,
            right: 56,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
        ],
      ),

      // Boton flotante para crear un nuevo vehículo
      floatingActionButton: Transform.translate(
        offset: const Offset(-16, 0),
        child: FloatingActionButton(
          onPressed: () {
            context.push('/car/list/register', extra: {
              'originPage': '/car/list',
            });
          },
          backgroundColor: const Color(0xFF00A48B),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white, 
            size: 36,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _headerVehicles(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 30),
      height: MediaQuery.of(context).size.height * 0.16,
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
        'MIS VEHÍCULOS',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 19
        ),
      ),
    );
  }
}