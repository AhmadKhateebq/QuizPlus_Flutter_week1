import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Text text;
  final Color color;
  final VoidCallback action;
  final double height;
  final double width;

  const CardWidget(
      {super.key, required this.text, required this.color, required this.action, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: height,
      width: width,
      child: TextButton(
        onPressed: action,
        child: text,
      ),
    );
  }
}
