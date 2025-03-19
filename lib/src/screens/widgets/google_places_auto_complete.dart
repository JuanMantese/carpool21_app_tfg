import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

// ignore: must_be_immutable
class GooglePlacesAutoComplete extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  Function(Prediction prediction) onPlaceSelected;
  final bool enabled; // Verifico si el valor se pre-selecciono

  GooglePlacesAutoComplete(
    this.controller, 
    this.hintText, 
    this.onPlaceSelected, 
    {
      super.key,
      this.enabled = false, 
    }
  );

  @override
  Widget build(BuildContext context) {
    print('GooglePlacesAutoComplete -----------------');
    print('Pre-SELECTED $enabled');
    
    if (enabled) {
      // Si enabled es true, muestra un TextField deshabilitado
      return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          enabled: false, // Vuelvo a setearla en false
        ),
      );
    }
    
    return SizedBox(
      height: 50,
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: "AIzaSyBwylGszcGHB5poVVHIDBUaTj9oNqwYk3Y", // GOOGLEMAPS API KEY
        boxDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        inputDecoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: const ["ar"], // Lugares que voy a poder buscar en el mapa - ar = Argentina
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: onPlaceSelected,
        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0)
          );
        },
        seperatedBuilder: const Divider(),
        containerHorizontalPadding: 18,

        // Customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 7),
                Expanded(child: Text(prediction.description ?? ""))
              ],
            ),
          );
        },
        isCrossBtnShown: true,
        // default 600 ms ,
      ),
    );
  }
}