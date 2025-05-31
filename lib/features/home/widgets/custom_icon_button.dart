import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomIconButton({super.key, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(child: Icon(icon, size: 40, color: Colors.white)),
      ),
    );
  }
}
