import 'package:flutter/material.dart';

class NotFoundData extends StatelessWidget {
  const NotFoundData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "ไม่พบข้อมูล.",
        style: TextStyle(
          fontSize: 28,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
