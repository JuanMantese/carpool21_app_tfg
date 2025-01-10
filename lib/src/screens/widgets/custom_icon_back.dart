import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomIconBack extends StatelessWidget {

  Function() onPressed;
  Color color;
  EdgeInsetsGeometry? margin;

  CustomIconBack({
    super.key, 
    required this.onPressed,
    this.color = Colors.white,
    this.margin
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: margin,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          Icons.arrow_back_ios,
          size: 30,
          color: color,
        )
      ),
    );
  }
}