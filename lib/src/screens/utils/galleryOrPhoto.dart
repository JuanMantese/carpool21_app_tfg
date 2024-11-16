import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


GalleryOrPhotoDialog(BuildContext context, Function() pickImage, Function() takePhoto) {

  // Modal to choose the camera or gallery
  return showDialog(
    context: context, 
    builder: (BuildContext context) => 
      AlertDialog(
        title: const Text(
          '¿De dónde te gustaría subir la foto?',
          style: TextStyle(
            fontSize: 17
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Navigator.pop(context);
              context.pop();
              pickImage();
            }, 
            child: const Text(
              'Galería',
              style: TextStyle(
                color: Colors.black
              ),
            )
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.pop(context);
              context.pop();
              takePhoto();
            }, 
            child: const Text(
              'Cámara',
              style: TextStyle(
                color: Colors.black
              ),
            )
          ),
        ],
      )
  );
}