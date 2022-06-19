import 'package:flutter/material.dart';

import '../consttants.dart';

class PrimaryText extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;

  PrimaryText({
    Key? key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.color = KPrimary,
    this.size = 16,
    this.height = 1.3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        height: height,
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
