import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/bloc/carListState.dart';
import 'package:carpool_21_app/src/screens/pages/carInfo/list/carItem.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CarListContent extends StatelessWidget {
  
  CarListState state;
  List<CarInfo>? carResponse;

  CarListContent(this.state, this.carResponse, {super.key});

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
              // itemCount: state.testingArrayCars?.length,
              itemCount: carResponse?.length,
              itemBuilder: (context, index) {
                return CarItem(
                  car: carResponse![index]
                  // car: state.testingArrayCars![index]
                );
              },
            ),
          ),

          _headerVehicles(context),
          CustomIconBack(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
            onPressed: () {
              // Navigator.pop(context);
              context.pop();
            },
          ),

          // Decoration
          Positioned(
            top: 108,
            right: 108,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          Positioned(
            top: 66,
            right: 90,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          Positioned(
            top: 100,
            right: 76,
            child: Icon(Icons.add_rounded, color: Colors.teal),
          ),
          Positioned(
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
            // Navigator.pushNamed(context, '/car/register', arguments: '/car/list');
            context.push('/car/list/register', extra: {
              'originPage': '/car/list',
            });
          },
          backgroundColor: Color(0xFF00A48B),
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