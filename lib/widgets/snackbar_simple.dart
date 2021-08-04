import 'package:flutter/material.dart';

class SnackBarSimple extends SnackBar {
  final String text;
  final Color color;
  final IconData iconData;

  SnackBarSimple({
    required this.text,
    required this.color,
    required this.iconData,
  }) : super(
          content: Row(
            children: [
              Icon(iconData, color: color),
              SizedBox(width: 10),
              Text(text),
            ],
          ),
        );
}
