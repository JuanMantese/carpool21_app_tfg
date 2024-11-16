import 'package:carpool_21_app/src/domain/models/carInfo.dart';
import 'package:carpool_21_app/src/domain/models/timeAndDistanceValue.dart';
import 'package:carpool_21_app/src/screens/pages/driver/mapBookingInfo/bloc/driverMapBookingInfoState.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTripContent extends StatelessWidget {
  
  final String neighborhoodPreSelected;
  final String pickUpText;
  final String destinationNeighborhood;
  final String destinationText;
  final TimeAndDistanceValues timeAndDistanceValues;
  final List<CarInfo> vehicleList;
  final DriverMapBookingInfoState state;
  final ValueChanged<String?> onNeighborhoodChanged;
  final ValueChanged<int?> onVehicleChanged;
  final ValueChanged<String?> onAvailableSeatsChanged;
  final ValueChanged<String?> onTripDescriptionChanged;
  final VoidCallback onConfirm;

  CreateTripContent({
    required this.neighborhoodPreSelected,
    required this.pickUpText,
    required this.destinationNeighborhood,
    required this.destinationText,
    required this.timeAndDistanceValues,
    required this.vehicleList,
    required this.state,
    required this.onNeighborhoodChanged,
    required this.onVehicleChanged,
    required this.onAvailableSeatsChanged,
    required this.onTripDescriptionChanged,
    required this.onConfirm,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTripInfoCard(context),
        SizedBox(height: 40.0),
        _buildDetailForm(context),
        SizedBox(height: 16.0),
        CustomButton(
          text: 'Confirmar Viaje',
          onPressed: onConfirm,
        ),
      ],
    );
  }

  Widget _buildTripInfoCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(
                Icons.my_location,
                color: Color(0xFF3b82f6),
              ),
              title: Text(
                pickUpText,
              ),
              titleTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.location_on,
                color: Color(0xFFdc2627),
              ),
              title: Text(destinationText),
              titleTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black
              ),
            ),

            // SizedBox(
            //   height: 200,
            //   child: GoogleMap(
            //     mapType: MapType.normal,
            //     myLocationButtonEnabled: false,
            //     initialCameraPosition: state.cameraPosition,
            //     markers: Set<Marker>.of(state.markers.values),
            //     polylines: Set<Polyline>.of(state.polylines.values),
            //     onMapCreated: (GoogleMapController controller) {
            //       if (state.controller != null) {
            //         if (!state.controller!.isCompleted) {
            //           state.controller?.complete(controller);
            //         }
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          onChanged: onNeighborhoodChanged,
          // validator: validator,
          decoration: InputDecoration(
            labelText: neighborhoodPreSelected == 'pickUpNeighborhood' ? 'Barrio de Destino' : 'Barrio de Origen',
            labelStyle: const TextStyle(color: Color(0xFF006D59)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Color(0xFF006D59)),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 16.0),

        DropdownButtonFormField<int>(
          decoration: InputDecoration(
            labelText: 'Vehículo',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          value: null,
          items: 
            vehicleList.map<DropdownMenuItem<int>>((CarInfo vehicle) {
              return DropdownMenuItem<int>(
                value: vehicle.idVehicle,
                child: Text('${vehicle.brand} - ${vehicle.model} - (${vehicle.patent})'),
              );
            }).toList(),
          onChanged: onVehicleChanged,
        ),
        const SizedBox(height: 16.0),

        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Plazas disponibles',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          items: <String>['1', '2', '3', '4', '5', '6']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onAvailableSeatsChanged,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          maxLength: 200,
          minLines: 4,
          maxLines: null,
          decoration: InputDecoration(
            labelText: 'Descripción',
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: onTripDescriptionChanged,
        ),
      ],
    );
  }
}