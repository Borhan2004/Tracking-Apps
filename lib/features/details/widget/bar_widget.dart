import 'package:flutter/material.dart';

class BarWidget extends StatelessWidget {
  final double barHeight;

  const BarWidget({super.key, required this.barHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 3),
      width: 30,
      height: barHeight,
      decoration: BoxDecoration(
        color: Colors.tealAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          barHeight.toString(),
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
