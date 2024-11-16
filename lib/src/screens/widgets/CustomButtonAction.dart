import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButtonAction extends StatelessWidget {

  String text;
  IconData icon;
  Function() onTapFunction;
  Color colorTop;
  Color colorBottom;
  EdgeInsetsGeometry? margin;
  EdgeInsetsGeometry? padding;

  CustomButtonAction({
    super.key, 
    required this.text,
    required this.icon,
    required this.onTapFunction,
    this.colorTop = const Color.fromARGB(255, 0, 64, 52),
    this.colorBottom = const Color(0xFF00A48B),
    this.margin = const EdgeInsets.only(left: 40, right: 40, top: 15),
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapFunction();
      },
      child: Container(
        margin: margin,
        child: ListTile(
          title: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorTop, // Top color
                  colorBottom, // Bottom color
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50))
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}