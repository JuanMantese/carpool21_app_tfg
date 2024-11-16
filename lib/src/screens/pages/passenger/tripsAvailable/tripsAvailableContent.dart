import 'package:carpool_21_app/src/domain/models/tripDetail.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/bloc/tripsAvailableState.dart';
import 'package:carpool_21_app/src/screens/pages/passenger/tripsAvailable/tripsAvailableItem.dart';
import 'package:carpool_21_app/src/screens/widgets/CustomIconBack.dart';
import 'package:carpool_21_app/src/screens/widgets/SearchBar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripsAvailableContent extends StatelessWidget {

  final TripsAvailableState state;
  final List<TripDetail> passengerRequests;
  final List<TripDetail> filteredRequests;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback onShowAdvancedOptions;

  TripsAvailableContent(this.state, {
    super.key,
    required this.passengerRequests,
    required this.filteredRequests,
    required this.searchController,
    required this.onSearch,
    required this.onShowAdvancedOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [ 
          _headerTripsAvailable(context),
          CustomIconBack(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15, left: 30),
            onPressed: () {
              // Navigator.pop(context);
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

          // Permite listar los viajes disponibles - vienen dentro de una Lista
          Container(
            margin: const EdgeInsets.only(top: 170, bottom: 40),
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: ListView.builder(
              itemCount: filteredRequests.length,
              itemBuilder: (context, index) {
                return TripsAvailableItem(state, filteredRequests[index]);
              },
            )
          ),

          SearchWidget(
            searchController: searchController,
            onSearch: onSearch,
          ),

          Positioned(
            top: 168,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.filter_alt_rounded, color: Colors.teal),
              // onPressed: () {
              //   _showAdvancedOptionsModal(context);
              // },
               onPressed: onShowAdvancedOptions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerTripsAvailable(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.16,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 73, 60), // Top color
            Color(0xFF00A48B), // Bottom color
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30), 
          bottomRight: Radius.circular(30), 
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A48B).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 10), // Shadow offset distance in x,y
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          bottom: 20, 
          right: 15, 
          left: 15, 
        ),
        child: Image.asset(
          'lib/assets/img/Header-Logo-Mini.png',
          height: 400,
          width: 600,
        ),
      ),
    );
  }

}