import 'dart:ui';

import 'package:flutter/material.dart';

class FloatingMessage extends StatefulWidget {
  final Duration displayDuration;
  final VoidCallback onUpdate;

  const FloatingMessage({
    super.key, 
    this.displayDuration = const Duration(seconds: 5),
    required this.onUpdate,
  });

  @override
  _FloatingMessageState createState() => _FloatingMessageState();
}

class _FloatingMessageState extends State<FloatingMessage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    // Inicializa el AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Define la animación para el ancho
    _widthAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Comienza la animación de colapso después de mostrar el mensaje
    Future.delayed(widget.displayDuration, () {
      if (!mounted) return; // Verifica si el widget sigue montado
      _controller.forward().then((_) {
        if (mounted) {
          setState(() {
            _showButton = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mensaje flotante con fondo borroso
        Positioned(
          bottom: 70,
          left: 0,
          right: 0,
          child: ClipRect(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizeTransition(
                sizeFactor: _widthAnimation,
                axis: Axis.horizontal,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Sombra más fuerte cerca
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 0), // Desenfoque uniforme
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0), // Sombra más suave más lejos
                            spreadRadius: 15,
                            blurRadius: 30,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Radio de 8px
                        child: Container(
                          height: 50,
                          color: const Color.fromARGB(255, 0, 87, 109),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Nuevos Viajes Disponibles',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Actualizar arriba',
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Botón flotante
        if (_showButton)
          Positioned(
            top: 76,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Color de la sombra
                    blurRadius: 20, // Grado de difuminado
                    spreadRadius: 0, // Extensión de la sombra
                    offset: const Offset(0, 4), // Desplazamiento horizontal y vertical
                  ),
                ],
              ),
              child: FloatingActionButton(
                heroTag: 'update_trips_button',
                backgroundColor: Colors.transparent, // Fondo del FAB
                elevation: 0, // Desactiva la sombra predeterminada
                onPressed: widget.onUpdate,
                child: Image.asset(
                  'lib/assets/img/refresh_notification.png', // Ruta de tu imagen
                  fit: BoxFit.contain, // Ajusta la imagen dentro del FAB
                  height: 34, // Altura de la imagen
                  width: 34, // Ancho de la imagen
                ),
              ),
            ),
          ),
      ],
    );
  }
}
