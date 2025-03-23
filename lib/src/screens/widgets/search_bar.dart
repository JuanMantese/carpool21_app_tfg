import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SearchWidget({
    super.key,
    required this.searchController, 
    required this.onSearch
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 90),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        elevation: 5, // Controla la intensidad de la sombra
        shadowColor: Colors.black45, // Color de la sombra
        borderRadius: BorderRadius.circular(24),
        child: TextField(
          controller: searchController,
          onChanged: onSearch,
          decoration: InputDecoration(
            hintText: 'Busca tu viaje...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none, // Sin bordes
            ),
            filled: true,
            fillColor: Colors.white, // Fondo blanco del TextField
          ),
        ),
      ),
    );
  }
}