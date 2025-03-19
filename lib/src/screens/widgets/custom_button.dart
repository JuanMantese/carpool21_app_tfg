import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final Function()? onPressed;
  final String text;
  final Color color;
  final Color textColor;
  // IconData icon;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const CustomButton({
    super.key, 
    required this.text,
    required Function() onPressed,
    this.color = const Color(0xFF00A98F),
    this.textColor = Colors.white,
    // this.icon = Icons.visibility,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.isEnabled = true
  }) : onPressed = isEnabled ? onPressed : null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? color : const Color.fromARGB(255, 187, 187, 187),
          minimumSize: const Size(double.infinity, 60), // width and heigh
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}