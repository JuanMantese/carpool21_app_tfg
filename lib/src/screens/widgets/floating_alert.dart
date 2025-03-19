import 'package:flutter/material.dart';

enum AlertType { success, error, info, warning }

void showOverlayMessage(
  BuildContext context, 
  String message,
  {
    String? customTitle,
    AlertType type = AlertType.success, 
  }
) {
  late OverlayEntry overlayEntry;
  bool isVisible = true; // Variable para controlar la visibilidad

  final alertConfig = {
    AlertType.success: {
      'color': Colors.green,
      'icon': Icons.check_circle,
      'title': 'Exitoso',
    },
    AlertType.error: {
      'color': Colors.red,
      'icon': Icons.error,
      'title': 'Error',
    },
    AlertType.info: {
      'color': Colors.blue,
      'icon': Icons.help,
      'title': 'Información',
    },
    AlertType.warning: {
      'color': Colors.orange,
      'icon': Icons.warning,
      'title': 'Alerta',
    },
  };

  final config = alertConfig[type]!;
  final Color backgroundColor = config['color'] as Color;
  final IconData iconData = config['icon'] as IconData;
  final String title = customTitle ?? config['title'] as String;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: MediaQuery.of(context).size.height * 0.10, // Posición superior
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  if (isVisible) {
                    isVisible = false;
                    overlayEntry.remove();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  // Eliminar el mensaje después de 5 segundos
  Future.delayed(const Duration(seconds: 5), () {
    if (isVisible) {
      isVisible = false;
      overlayEntry.remove();
    }
  });
}
