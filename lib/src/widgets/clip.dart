import 'package:flutter/material.dart';

class Clip extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(10, size.height / 2 - 120, size.width - 20, 260),
          const Radius.circular(26)));
    return path;
  }

  @override
  bool shouldReclip(oldClipper) {
    return true;
  }
}
