import 'package:flutter/material.dart';

class EmptyStateCard extends StatelessWidget {
  final String image;
  final String message;

  const EmptyStateCard({
    super.key,
    required this.image,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(28.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Color de la sombra
            spreadRadius: 2, // Expansión de la sombra
            blurRadius: 8, // Difusión de la sombra
            offset: const Offset(0, 4), // Dirección de la sombra (desplazamiento en el eje X y Y)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Text( 
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF006D59),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
